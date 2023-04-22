
output "service" {
  value       = google_cloud_run_service.client.status[0].url
  description = "The URL on which the deployed service is available"
}