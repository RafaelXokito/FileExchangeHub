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

variable "file_gateway_image" {
  type        = string
  description = "The Docker image for the file-gateway server."
}

variable "client_image" {
  type        = string
  description = "The Docker image for the client."
  default = "latest"
}

variable "server_image_tag" {
  type        = string
  description = "The Docker image_tag for the Express server."
  default = "latest"
}

variable "socket_server_image_tag" {
  type        = string
  description = "The Docker image_tag for the Socket.io server."
  default = "latest"
}

variable "file_gateway_image_tag" {
  type        = string
  description = "The Docker image_tag for the file-gateway server."
  default = "latest"
}

variable "client_image_tag" {
  type        = string
  description = "The Docker image_tag for the client."
  default = "latest"
}

variable "mongo_connection_string" {
  type = string
  description = "The mongo connection string"  
}

# variable "azure_client_id" {
#   type        = string
#   description = "The azure client id."
# }

# variable "azure_client_secret" {
#   type        = string
#   description = "The azure client secret."
# }

# variable "azure_subscription_id" {
#   type        = string
#   description = "The subscription id."
# }

# variable "azure_tenant_id" {
#   type        = string
#   description = "The tenant id."
# }