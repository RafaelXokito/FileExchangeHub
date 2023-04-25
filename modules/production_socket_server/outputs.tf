output "socket_server_uri" {
  value = google_cloud_run_v2_service.socket_server.uri
  description = "The URI of the socket server service."
}
