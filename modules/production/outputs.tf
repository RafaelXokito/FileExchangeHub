
output "service" {
  value       = google_cloud_run_v2_service.client.uri
  description = "The URL on which the deployed service is available"
}

output "domain_service" {
  value       = google_cloud_run_domain_mapping.dnsmap.name
  description = "The domain on which the deployed service is available"
}