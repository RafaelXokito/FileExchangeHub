output "server_uri" {
  value = google_cloud_run_v2_service.server.uri
  description = "The URI of the server service."
}
