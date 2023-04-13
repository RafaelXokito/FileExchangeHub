variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "external_port" {
 type = number
 description = "External port for nginx"
 default = 8080
}

variable "server_image" {
  type        = string
  description = "The Docker image for the Express server."
}

variable "socket_server_image" {
  type        = string
  description = "The Docker image for the Socket.io server."
}

variable "client_image" {
  type        = string
  description = "The Docker image for the client."
}

variable "database_image" {
  type        = string
  description = "The Docker image for the database."
}

variable "mongo_connection_string" {
  type = string
  description = "The mongo connection string"  
}