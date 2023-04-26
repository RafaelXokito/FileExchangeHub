output "production_service" {
  value       = module.production_client.service
  description = "The URL on which the production deployed service is available"
}

output "production_domain_service" {
  value       = module.production_client.domain_service
  description = "The domain on which the production deployed service is available"
}

output "development_client_url" {
  value       = module.development.client_url
  description = "The accessible URL for the client container in development environment"
}

output "connection_strings" {
  value       = module.production_db.connection_strings
  description = "The connection string where db service is available"
}

output "server_uri" {
  value = module.production_server.server_uri
  description = "The URI of the server service."
}

output "gateway_uri" {
  value = module.production_gateway.gateway_uri
  description = "The URI of the file gateway service."
}

output "socket_server_uri" {
  value = module.production_socket_server.socket_server_uri
  description = "The URI of the socket server service."
}
