variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "server_image" {
  type        = string
  description = "The Docker image for the Express server."
}

variable "socket_server_image" {
  type        = string
  description = "The Docker image for the Socket.io server."
}

variable "file_gateway_image" {
  type        = string
  description = "The Docker image for the file-gateway server."
}

variable "client_image" {
  type        = string
  description = "The Docker image for the client."
}

variable "mongo_connection_string" {
  type = string
  description = "The mongo connection string"  
}