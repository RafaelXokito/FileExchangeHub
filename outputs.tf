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
