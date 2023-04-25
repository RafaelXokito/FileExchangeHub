module "production_atlas" {
  source = "./modules/production_atlas"

  public_key      = var.mongo_public_key
  private_key     = var.mongo_private_key
  org_id          = var.mongo_org_id
  dbuser          = var.mongo_dbuser
  dbuser_password = var.mongo_dbuser_password
}

module "production" {
    source = "./modules/production"
    
    project_id              = var.project_id
    client_image            = var.client_image
    server_image            = var.server_image
    socket_server_image     = var.socket_server_image
    file_gateway_image      = var.file_gateway_image

    mongo_dbuser            = var.mongo_dbuser
    mongo_dbuser_password   = var.mongo_dbuser_password
    
    mongo_connection_string = module.production_atlas.connection_strings
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