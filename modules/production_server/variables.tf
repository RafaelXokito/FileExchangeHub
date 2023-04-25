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

variable "gateway_uri" {
  description = "The URI of the gateway service."
  type        = string
}