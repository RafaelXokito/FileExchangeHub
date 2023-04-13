terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
    google = {
      source = "hashicorp/google"
      version = "4.58.0"
    }
  }
}
provider "docker" {}

resource "docker_image" "client" {
  name = var.client_image
  keep_locally = false
}

resource "docker_image" "server" {
  name = var.server_image
  keep_locally = false
}

resource "docker_image" "socket_server" {
  name = var.socket_server_image
  keep_locally = false
}

resource "docker_image" "database" {
  name = var.database_image
  keep_locally = false
}

# GOOGLE

provider "google" {
  credentials = file("auth.json")
  project = var.project_id
  region  = "us-central1"
}

locals {
  mongo_connection_string = var.mongo_connection_string
}


resource "google_cloud_run_service" "client" {
  name     = "client-service"
  location = "us-central1"

  template {
    spec {
      containers {
        image = var.client_image
        env {
          name  = "MONGO_CONNECTION_STRING"
          value = local.mongo_connection_string
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service" "server" {
  name     = "server-service"
  location = "us-central1"

  template {
    spec {
      containers {
        image = var.server_image
        env {
          name  = "MONGO_CONNECTION_STRING"
          value = local.mongo_connection_string
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service" "socket_server" {
  name     = "socket-server-service"
  location = "us-central1"

  template {
    spec {
      containers {
        image = var.socket_server_image
        env {
          name  = "MONGO_CONNECTION_STRING"
          value = local.mongo_connection_string
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
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

resource "google_cloud_run_service_iam_policy" "client_policy" {
  project  = google_cloud_run_service.client.project
  location = google_cloud_run_service.client.location
  service  = google_cloud_run_service.client.name
  policy_data = data.google_iam_policy.public.policy_data
}

resource "google_cloud_run_service_iam_policy" "server_policy" {
  project  = google_cloud_run_service.server.project
  location = google_cloud_run_service.server.location
  service  = google_cloud_run_service.server.name
  policy_data = data.google_iam_policy.public.policy_data
}

resource "google_cloud_run_service_iam_policy" "socket_server_policy" {
  project  = google_cloud_run_service.socket_server.project
  location = google_cloud_run_service.socket_server.location
  service  = google_cloud_run_service.socket_server.name
  policy_data = data.google_iam_policy.public.policy_data
}
