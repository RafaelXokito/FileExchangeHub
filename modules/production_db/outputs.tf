output "connection_strings" {
  value = mongodbatlas_advanced_cluster.cluster.connection_strings[0].standard_srv
}
