variable "project_id" {
  type        = string
  description = "Unique identifier for the project"
  default     = ""
}
variable "client_image" {
  type        = string
  description = "Docker image for the client application"
  default     = ""
}
variable "server_image" {
  type        = string
  description = "Docker image for the server application"
  default     = ""
}
variable "socket_server_image" {
  type        = string
  description = "Docker image for the socket server"
  default     = ""
}
variable "file_gateway_image" {
  type        = string
  description = "Docker image for the file gateway"
  default     = ""
}
variable "server_uri" {
  type        = string
  description = "URI for the server application"
  default     = ""
}
variable "socket_server_uri" {
  type        = string
  description = "URI for the socket server"
  default     = ""
}
variable "gateway_uri" {
  type        = string
  description = "URI for the file gateway"
  default     = ""
}
variable "mongo_connection_string" {
  type        = string
  description = "Connection string to connect to the MongoDB Atlas cluster"
  default     = ""
}
variable "mongo_public_key" {
  type        = string
  description = "Public Programmatic API key to authenticate to Atlas"
  default     = ""
}
variable "mongo_private_key" {
  type        = string
  description = "Private Programmatic API key to authenticate to Atlas"
  default     = ""
}
variable "mongo_org_id" {
  type        = string
  description = "MongoDB Organization ID"
  default     = ""
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
