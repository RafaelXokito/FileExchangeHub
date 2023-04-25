variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
  default = ""
}

variable "socket_server_image" {
  type        = string
  description = "The Docker image for the Socket.io server."
  default = ""
}