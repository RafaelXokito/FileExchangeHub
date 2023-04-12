terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
    # google = {
    #   source = "hashicorp/google"
    #   version = "4.58.0"
    # }
  }
}
provider "docker" {}
# provider "google" {
#   project = var.project_id
# }

# resource "google_compute_network" "vpc_network" {
#   name = "terraform-network"
# }

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


# resource "google_cloud_run_v2_service" "default" {
#   name     = "client-service"
#   location = "us-central1"
#   ingress = "INGRESS_TRAFFIC_ALL"

#   template {
#     containers {
#       image = var.client_image
#       ports {
#         container_port = 80
#       }
#     }
#   }
# }

# resource "google_cloud_run_v2_service" "server" {
#   name     = "server-service"
#   location = "us-central1"
#   ingress = "INGRESS_TRAFFIC_ALL"

#   template {
#     containers {
#       image = var.server_image
#       ports {
#         container_port = 80
#       }
#     }
#   }
# }

# resource "google_cloud_run_v2_service" "socket_server" {
#   name     = "socket-server-service"
#   location = "us-central1"
#   ingress = "INGRESS_TRAFFIC_ALL"

#   template {
#     containers {
#       image = var.socket_server_image
#       ports {
#         container_port = 80
#       }
#     }
#   }
# }

# resource "google_sql_database_instance" "mongodb_instance" {
#   name             = "mongodb-instance"
#   database_version = "MONGODB_4_2"
#   region           = "us-central1"

#   settings {
#     tier = "db-f1-micro"

#     ip_configuration {
#       ipv4_enabled = true
#       authorized_networks {
#         value = "0.0.0.0/0"
#       }
#     }
#   }
# }

# data "google_iam_policy" "public" {
#   binding {
#     role = "roles/run.invoker"
#     members = [
#       "allUsers",
#     ]
#   }
# }

# resource "google_cloud_run_v2_service_iam_policy" "policy" {
#   project = google_cloud_run_v2_service.default.project
#   location = google_cloud_run_v2_service.default.location
#   name = google_cloud_run_v2_service.default.name
#   policy_data = data.google_iam_policy.public.policy_data
# }