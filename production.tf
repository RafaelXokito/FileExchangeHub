variable "client_image_tag" {
  type        = string
  description = "The Docker image_tag for the client."
  default     = "latest"
}

variable "server_image_tag" {
  type        = string
  description = "The Docker image_tag for the Express server."
  default     = "latest"
}

variable "socket_server_image_tag" {
  type        = string
  description = "The Docker image_tag for the Socket.io server."
  default     = "latest"
}

variable "file_gateway_image_tag" {
  type        = string
  description = "The Docker image_tag for the file-gateway server."
  default     = "latest"
}

module "production" {
  source = "./modules/production"
  
  # Pass any required variables here

  external_port = 3000

  project_id = "fileexchangehub"
  server_image      = "rafaelxokito/fileexchangehubserver"
  socket_server_image = "rafaelxokito/fileexchangehubsocketserver"
  client_image       = "rafaelxokito/fileexchangehubclient"
  file_gateway_image       = "rafaelxokito/fileexchangehubfilegateway"
  mongo_connection_string = "mongodb+srv://admin:admin@fileexchangehub.vfybz5q.mongodb.net/test"

  client_image_tag       = var.client_image_tag
  server_image_tag       = var.server_image_tag
  socket_server_image_tag = var.socket_server_image_tag
  file_gateway_image_tag = var.file_gateway_image_tag

  # azure_client_id = ""
  # azure_client_secret = ""
  # azure_subscription_id = "139dfd40-9d71-4ada-a60f-5f0ec09fddd1"
  # azure_tenant_id = "536b85ad-a448-4186-a9af-e3ccad3302c5"
}

terraform {
  backend "gcs" {
    bucket = "fileexchangehub-terraform"
    prefix  = "terraform/state"
    credentials = "./auth.json"
  }
}