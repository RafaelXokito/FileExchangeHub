variable "public_key" {
  type        = string
  description = "Public Programmatic API key to authenticate to Atlas"
}
variable "private_key" {
  type        = string
  description = "Private Programmatic API key to authenticate to Atlas"
}
variable "org_id" {
  type        = string
  description = "MongoDB Organization ID"
}
variable "dbuser_password" {
  type        = string
  description = "MongoDB Atlas Database User Password"
}
variable "dbuser" {
  type        = string
  description = "MongoDB Atlas Database User"
}


