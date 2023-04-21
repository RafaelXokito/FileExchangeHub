terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.58.0"
    }
    # azurerm = {
    #   source = "hashicorp/azurerm"
    #   version = "3.52.0"
    # }
  }
}

# GOOGLE PROVIDER

provider "google" {
  credentials = file("auth.json")
  project = var.project_id
  region  = "europe-west1"
}

locals {
  mongo_connection_string = var.mongo_connection_string
}

resource "google_cloud_run_v2_service" "server" {
  name     = "server-service"
  location = "europe-west1"
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.server_image}:${var.server_image_tag}"
      env {
        name  = "DATABASE_URI"
        value = local.mongo_connection_string
      }
      env {
        name  = "FILE_GATEWAY_URI"
        value = "${google_cloud_run_v2_service.file-gateway.uri}"
      }
    }
  }
}

resource "google_cloud_run_v2_service" "socket_server" {
  name     = "socket-server-service"
  location = "europe-west1"
  ingress = "INGRESS_TRAFFIC_ALL"
  
  template {
    containers {
      image = "${var.socket_server_image}:${var.socket_server_image_tag}"
    }
  }
}

resource "google_cloud_run_v2_service" "file-gateway" {
  name     = "file-gateway-service"
  location = "europe-west1"
  ingress = "INGRESS_TRAFFIC_ALL"
  
  template {
    containers {
      image = "${var.file_gateway_image}:${var.file_gateway_image_tag}"
      env {
        name  = "IS_PRODUCTION"
        value = "TRUE"
      }
    }
  }
}

resource "google_cloud_run_service" "client" {
  name     = "client-service"
  location = "europe-west1"

  template {
    spec {
      containers {
        image = "${var.client_image}:${var.client_image_tag}"
        env {
          name  = "SERVER_URI"
          value = "${google_cloud_run_v2_service.server.uri}"
        }
        env {
          name  = "SOCKET_URI"
          value = "${google_cloud_run_v2_service.socket_server.uri}"
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_domain_mapping" "dnsmap" {
  location = "europe-west1"
  name     = "filexchangehub.com"

  metadata {
    namespace = "FileExchangeHub"
  }

  spec {
    route_name = google_cloud_run_service.client.name
  }
}

resource "google_dns_managed_zone" "zone" {
  name        = "filexchangehub-com"
  dns_name    = "filexchangehub.com."
  description = "Managed DNS zone for filexchangehub.com"
}

resource "google_dns_record_set" "example_a" {
  managed_zone = google_dns_managed_zone.zone.name
  name         = "filexchangehub.com."
  type         = "A"
  ttl          = 300
  rrdatas      = [
    for rr in google_cloud_run_domain_mapping.dnsmap.status[0].resource_records :
    rr.rrdata if rr.type == "A"
  ]
}

resource "google_dns_record_set" "example_aaaa" {
  managed_zone = google_dns_managed_zone.zone.name
  name         = "filexchangehub.com."
  type         = "AAAA"
  ttl          = 300
  rrdatas      = [
    for rr in google_cloud_run_domain_mapping.dnsmap.status[0].resource_records :
    rr.rrdata if rr.type == "AAAA"
  ]
}

resource "google_storage_bucket" "bucket" {
  name          = "fileexchange-bucket"
  location      = "europe-west1"
  force_destroy = true
  storage_class = "STANDARD"

  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "Delete"
    }
  }
}


data "google_iam_policy" "public" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

data "google_iam_policy" "bucket_public" {
  binding {
    role = "roles/storage.objectViewer"
    members = [
      "allUsers",
    ]
  }
}


resource "google_cloud_run_v2_service_iam_policy" "server_policy" {
  project  = google_cloud_run_v2_service.server.project
  location = google_cloud_run_v2_service.server.location
  name  = google_cloud_run_v2_service.server.name
  policy_data = data.google_iam_policy.public.policy_data
}

resource "google_cloud_run_v2_service_iam_policy" "socket_server_policy" {
  project  = google_cloud_run_v2_service.socket_server.project
  location = google_cloud_run_v2_service.socket_server.location
  name  = google_cloud_run_v2_service.socket_server.name
  policy_data = data.google_iam_policy.public.policy_data
}

resource "google_cloud_run_v2_service_iam_policy" "client_policy" {
  project  = google_cloud_run_service.client.project
  location = google_cloud_run_service.client.location
  name  = google_cloud_run_service.client.name
  policy_data = data.google_iam_policy.public.policy_data
}

resource "google_cloud_run_v2_service_iam_policy" "file_gateway_policy" {
  project  = google_cloud_run_v2_service.file-gateway.project
  location = google_cloud_run_v2_service.file-gateway.location
  name  = google_cloud_run_v2_service.file-gateway.name
  policy_data = data.google_iam_policy.public.policy_data
}

resource "google_storage_bucket_iam_policy" "bucket_policy" {
  bucket      = google_storage_bucket.bucket.name
  policy_data = data.google_iam_policy.bucket_public.policy_data
}
