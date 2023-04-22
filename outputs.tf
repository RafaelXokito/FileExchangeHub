output "production_service" {
  value       = module.production.service
  description = "The URL on which the production deployed service is available"
}

output "production_domain_service" {
  value       = module.production.domain_service
  description = "The domain on which the production deployed service is available"
}
