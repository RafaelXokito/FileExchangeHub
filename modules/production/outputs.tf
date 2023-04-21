
output "service" {
  value       = google_cloud_run_service.client.status
  description = "The URL on which the deployed service is available"
}

# output "domain_mapping_status" {
#   value = google_cloud_run_domain_mapping.dnsmap.status
# }