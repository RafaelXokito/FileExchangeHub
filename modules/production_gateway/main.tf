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

resource "google_cloud_run_v2_service" "file-gateway" {
  name     = "file-gateway-service"
  location = "europe-west1"
  ingress = "INGRESS_TRAFFIC_ALL"
  
  template {
    containers {
      image = "${var.file_gateway_image}"
      env {
        name  = "IS_PRODUCTION"
        value = "TRUE"
      }
    }
  }
}

# Bucket

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

# GCP Policies

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
