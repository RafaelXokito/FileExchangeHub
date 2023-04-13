terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "client" {
  name         = "projnginx"
  build {
    context = "./client"
  }
}

resource "docker_image" "server" {
  name         = "projserver"
  build {
    context = "./server"
  }
}

resource "docker_image" "socket_server" {
  name         = "socket-server"
  build {
    context = "./socket-server"
  }
}

resource "docker_network" "app_network" {
  name = "app_network"
}

resource "docker_container" "client" {
  image = docker_image.client.image_id
  name  = "client"
  ports {
    internal = 8080
    external = 8080
  }
  env = [
    "IS_PRODUCTION=FALSE",
    "SERVER_URI=http://localhost:3001",
    "SOCKET_URI=http://localhost:3002"
  ]
  networks_advanced {
    name = docker_network.app_network.name
  }
}

resource "docker_container" "server" {
  image = docker_image.server.image_id
  name  = "server"
  ports {
    internal = 3001
    external = 3001
  }
  env = [
    "DATABASE_URI=database",
  ]
  networks_advanced {
    name = docker_network.app_network.name
  }
  hostname = "server"
}

resource "docker_container" "socket_server" {
  image = docker_image.socket_server.image_id
  name  = "socket-server"
  ports {
    internal = 3002
    external = 3002
  }
  networks_advanced {
    name = docker_network.app_network.name
  }
  hostname = "socket-server"
}

resource "docker_container" "database" {
  image = "mongo:latest"
  name  = "database"
  ports {
    internal = 27017
    external = 27017
  }
  networks_advanced {
    name = docker_network.app_network.name
  }
  hostname = "database"
}