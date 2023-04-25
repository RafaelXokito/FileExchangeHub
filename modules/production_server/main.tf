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
  dbuser_and_password = "${var.mongo_dbuser}:${var.mongo_dbuser_password}"
  parts = split("://", var.mongo_connection_string)
  mongo_connection_string = length(local.parts) > 1 ? "${local.parts[0]}://${local.dbuser_and_password}@${local.parts[1]}/test" : ""
}

resource "google_cloud_run_v2_service" "server" {
  name     = "server-service"
  location = "europe-west1"
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.server_image}"
      env {
        name  = "DATABASE_URI"
        value = local.mongo_connection_string
      }
      env {
        name  = "FILE_GATEWAY_URI"
        value = "${var.gateway_uri}"
      }
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

resource "google_cloud_run_v2_service_iam_policy" "server_policy" {
  project  = google_cloud_run_v2_service.server.project
  location = google_cloud_run_v2_service.server.location
  name  = google_cloud_run_v2_service.server.name
  policy_data = data.google_iam_policy.public.policy_data
}