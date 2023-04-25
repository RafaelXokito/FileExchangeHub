terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.58.0"
    }
  }
}

# GOOGLE PROVIDER

provider "google" {
  credentials = file("auth.json")
  project = var.project_id
  region  = "europe-west1"
}

resource "google_cloud_run_v2_service" "client" {
  name     = "client-service"
  location = "europe-west1"
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
        image = "${var.client_image}"
        env {
          name  = "SERVER_URI"
          value = "${var.server_uri}"
        }
        env {
          name  = "SOCKET_URI"
          value = "${var.socket_server_uri}"
        }
    }
  }
}

# Cloud DNS & Domain Setting

resource "google_cloud_run_domain_mapping" "dnsmap" {
  location = "europe-west1"
  name     = "filexchangehub.com"

  metadata {
    namespace = "FileExchangeHub"
  }

  spec {
    route_name = google_cloud_run_v2_service.client.name
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

# GCP Policies

data "google_iam_policy" "public" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_v2_service_iam_policy" "client_policy" {
  project  = google_cloud_run_v2_service.client.project
  location = google_cloud_run_v2_service.client.location
  name  = google_cloud_run_v2_service.client.name
  policy_data = data.google_iam_policy.public.policy_data
}