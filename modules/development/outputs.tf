output "client_url" {
  description = "The accessible URL for the client container in development environment"
  value       = "http://localhost:${docker_container.client.ports[0].external}"
}
