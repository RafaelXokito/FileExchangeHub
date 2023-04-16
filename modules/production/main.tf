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

resource "google_cloud_run_v2_service" "client" {
  name     = "client-service"
  location = "europe-west1"
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
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

resource "google_storage_bucket" "bucket" {
  name          = "fileexchange-bucket"
  location      = "europe-west1"
  force_destroy = true
  storage_class = "STANDARD"

  uniform_bucket_level_access = true
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
  project  = google_cloud_run_v2_service.client.project
  location = google_cloud_run_v2_service.client.location
  name  = google_cloud_run_v2_service.client.name
  policy_data = data.google_iam_policy.public.policy_data
}

resource "google_cloud_run_v2_service_iam_policy" "file_gateway_policy" {
  project  = google_cloud_run_v2_service.file-gateway.project
  location = google_cloud_run_v2_service.file-gateway.location
  name  = google_cloud_run_v2_service.file-gateway.name
  policy_data = data.google_iam_policy.public.policy_data
}

resource "google_cloud_run_v2_service_iam_policy" "bucket_policy" {
  project  = google_storage_bucket.bucket.project
  location = google_storage_bucket.bucket.location
  name  = google_storage_bucket.bucket.name
  policy_data = data.google_iam_policy.bucket_public.policy_data
}


# AZURE PROVIDER

# provider "azurerm" {
#   client_id       = var.azure_client_id
#   client_secret   = var.azure_client_secret
#   subscription_id = var.azure_subscription_id
#   tenant_id       = var.azure_tenant_id
#   features {
    
#   }
# }

# resource "azurerm_resource_group" "fileexchangeazure" {
#   name     = "file-exchange-azure"
#   location = "West Europe"
# }

# resource "azurerm_storage_account" "fileexchangeazure" {
#   name                     = "file-exchange-azure"
#   resource_group_name      = azurerm_resource_group.fileexchangeazure.name
#   location                 = azurerm_resource_group.fileexchangeazure.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   public_network_access_enabled = true
#   account_kind = "BlobStorage"
# }

# resource "azurerm_storage_container" "fileexchangeazure" {
#   name                  = "content"
#   storage_account_name  = azurerm_storage_account.fileexchangeazure.name
#   container_access_type = "private"
# }

# resource "azurerm_storage_blob" "fileexchangeazure" {
#   name                   = "file-exchange-azure.zip"
#   storage_account_name   = azurerm_storage_account.fileexchangeazure.name
#   storage_container_name = azurerm_storage_container.fileexchangeazure.name
#   type                   = "Block"
#   source                 = "some-local-file.zip"
# }


# provider "azurerm" {
#   client_id       = var.azure_client_id
#   client_secret   = var.azure_client_secret
#   subscription_id = "139dfd40-9d71-4ada-a60f-5f0ec09fddd1"
#   tenant_id       = var.azure_tenant_id

#   features {}
# }
