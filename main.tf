module "production_client" {
    source = "./modules/production_client"
    
    project_id              = var.project_id
    client_image            = var.client_image

    server_uri              = var.server_uri
    socket_server_uri       = var.socket_server_uri
}

module "production_server" {
    source = "./modules/production_server"
    
    project_id              = var.project_id
    server_image            = var.server_image

    gateway_uri             = var.gateway_uri

    mongo_dbuser            = var.mongo_dbuser
    mongo_dbuser_password   = var.mongo_dbuser_password
    
    mongo_connection_string = var.mongo_connection_string
}

module "production_gateway" {
    source = "./modules/production_gateway"
    
    project_id              = var.project_id
    file_gateway_image      = var.file_gateway_image
}

module "production_socket_server" {
    source = "./modules/production_socket_server"
    
    project_id              = var.project_id
    socket_server_image     = var.socket_server_image
}

module "production_db" {
  source = "./modules/production_db"

  public_key      = var.mongo_public_key
  private_key     = var.mongo_private_key
  org_id          = var.mongo_org_id
  dbuser          = var.mongo_dbuser
  dbuser_password = var.mongo_dbuser_password
}

module "development" {
    source = "./modules/development"
}

terraform {
    backend "gcs" {
        bucket = "fileexchangehub-terraform"
        prefix  = "terraform/state"
        credentials = "./auth.json"
    }
}