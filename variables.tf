variable "project_id" {
  default = ""
}
variable "client_image" {
  default = ""
}
variable "server_image" {
  default = ""
}
variable "socket_server_image" {
  default = ""
}
variable "file_gateway_image" {
  default = ""
}
variable "mongo_connection_string" {
  default = ""
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