
output "service" {
  value       = google_cloud_run_v2_service.client.uri
  description = "The URL on which the deployed service is available"
}