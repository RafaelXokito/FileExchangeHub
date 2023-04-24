module "production_atlas" {
  source = "./modules/production_atlas"

  public_key      = var.mongo_public_key
  private_key     = var.mongo_private_key
  org_id          = var.mongo_org_id
  project_name    = var.mongo_project_name
  cluster_name    = var.mongo_cluster_name
  cloud_provider  = var.mongo_cloud_provider
  region          = var.mongo_region
  dbuser          = var.mongo_dbuser
  dbuser_password = var.mongo_dbuser_password
  database_name   = var.mongo_database_name
  cidr            = var.mongo_cidr

}

module "production" {
    source = "./modules/production"
    
    project_id              = var.project_id
    client_image            = var.client_image
    server_image            = var.server_image
    socket_server_image     = var.socket_server_image
    file_gateway_image      = var.file_gateway_image
    mongo_connection_string = replace(module.production_atlas.connection_strings, "//", format("//%s:%s@", var.mongo_dbuser, var.mongo_dbuser_password)) + format("/%s", var.mongo_database_name)
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