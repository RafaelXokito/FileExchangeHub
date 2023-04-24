terraform {
  required_providers {
    mongodbatlas = {
        source = "mongodb/mongodbatlas"
        version = "1.8.2"
    }
  }
}

provider "mongodbatlas" {
  public_key = var.public_key
  private_key  = var.private_key
}

resource "mongodbatlas_project" "project" {
  name   = var.project_name
  org_id = var.org_id
}

resource "mongodbatlas_project_ip_access_list" "ip" {
  project_id = mongodbatlas_project.project.id
  # ip_address = var.ip_address
  cidr_block = var.cidr  
  comment    = "IP Address for accessing the cluster"
}

resource "mongodbatlas_advanced_cluster" "cluster" {
  project_id             = mongodbatlas_project.project.id
  name                   = var.cluster_name
  cluster_type           = "REPLICASET"
  replication_specs {
    region_configs {
        provider_name                = var.cloud_provider
        backing_provider_name     =  "AWS"
        electable_specs {
            instance_size = "M0"
        }
        region_name     = var.region
        priority        = 1
    }
  }
}

resource "mongodbatlas_database_user" "user" {
  username           = var.dbuser
  password           = var.dbuser
  project_id         = mongodbatlas_project.project.id
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = var.database_name # The database name and collection name need not exist in the cluster before creating the user.
  }
  labels {
    key   = "Name"
    value = "DB User1"
  }
}