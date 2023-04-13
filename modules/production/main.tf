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

locals {
  mongo_connection_string = var.mongo_connection_string
}

resource "google_cloud_run_v2_service" "server" {
  name     = "server-service"
  location = "europe-west1"
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = var.server_image
      env {
        name  = "DATABASE_URI"
        value = local.mongo_connection_string
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
      image = var.socket_server_image
    }
  }
}

resource "google_cloud_run_v2_service" "client" {
  name     = "client-service"
  location = "europe-west1"
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = var.client_image
      env {
        name  = "IS_PRODUCTION"
        value = "TRUE"
      }
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
  project  = google_cloud_run_v2_service.client.project
  location = google_cloud_run_v2_service.client.location
  name  = google_cloud_run_v2_service.client.name
  policy_data = data.google_iam_policy.public.policy_data
}

data "google_iam_policy" "public" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}


# AZURE PROVIDER
# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~> 2.0"
#     }
#   }
# }

# provider "azurerm" {
#   client_id       = var.azure_client_id
#   client_secret   = var.azure_client_secret
#   subscription_id = "139dfd40-9d71-4ada-a60f-5f0ec09fddd1"
#   tenant_id       = var.azure_tenant_id

#   features {}
# }
