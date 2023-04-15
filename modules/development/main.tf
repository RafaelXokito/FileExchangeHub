terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

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

resource "docker_image" "file_gateway_server" {
  name         = "file-gateway"
  build {
    context = "./file-gateway"
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
    "FILE_GATEWAY_URI=http://file-gateway:3003"
  ]
  networks_advanced {
    name = docker_network.app_network.name
  }
  hostname = "server"
  volumes {
    container_path  = "/usr/app/uploads"
    host_path       = abspath("./server/uploads")
    read_only       = false
  }
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

resource "docker_container" "file_gateway_server" {
  image = docker_image.file_gateway_server.image_id
  name  = "file-gateway"
  ports {
    internal = 3003
    external = 3003
  }
  env = [
    "IS_PRODUCTION=FALSE",
  ]
  networks_advanced {
    name = docker_network.app_network.name
  }
  hostname = "file-gateway"
  volumes {
    container_path  = "/usr/app/uploads"
    host_path       = abspath("./file-gateway/uploads")
    read_only       = false
  }
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