variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
  default = ""
}

variable "client_image" {
  type        = string
  description = "The Docker image for the client."
  default = ""
}

variable "server_uri" {
  description = "The URI of the server service."
  type        = string
}

variable "socket_server_uri" {
  description = "The URI of the socket server service."
  type        = string
}
