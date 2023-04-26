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

resource "google_cloud_run_v2_service" "socket_server" {
  name     = "socket-server-service"
  location = "europe-west1"
  ingress = "INGRESS_TRAFFIC_ALL"
  
  template {
    containers {
      image = "${var.socket_server_image}"
    }
  }
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

resource "google_cloud_run_v2_service_iam_policy" "socket_server_policy" {
  project  = google_cloud_run_v2_service.socket_server.project
  location = google_cloud_run_v2_service.socket_server.location
  name  = google_cloud_run_v2_service.socket_server.name
  policy_data = data.google_iam_policy.public.policy_data
}
