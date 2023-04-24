module "production" {
    source = "./modules/production"
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