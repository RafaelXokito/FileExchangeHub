module "production" {
    source = "./modules/production"
    

    project_id              = var.project_id
    client_image            = var.client_image
    server_image            = var.server_image
    socket_server_image     = var.socket_server_image
    file_gateway_image      = var.file_gateway_image
    client_image_tag        = var.client_image_tag
    server_image_tag        = var.server_image_tag
    socket_server_image_tag = var.socket_server_image_tag
    file_gateway_image_tag  = var.file_gateway_image_tag
    mongo_connection_string = var.mongo_connection_string
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