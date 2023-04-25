variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
  default = ""
}

variable "server_image" {
  type        = string
  description = "The Docker image for the Express server."
  default = ""
}

variable "socket_server_image" {
  type        = string
  description = "The Docker image for the Socket.io server."
  default = ""
}

variable "file_gateway_image" {
  type        = string
  description = "The Docker image for the file-gateway server."
  default = ""
}

variable "client_image" {
  type        = string
  description = "The Docker image for the client."
  default = ""
}

variable "mongo_dbuser_password" {
  type        = string
  description = "MongoDB Atlas Database User Password"
  default     = ""
}

variable "mongo_dbuser" {
  type        = string
  description = "MongoDB Atlas Database User"
  default     = ""
}

variable "mongo_connection_string" {
  type = string
  description = "The mongo connection string"  
  default = ""
}
