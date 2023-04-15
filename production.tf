module "production" {
  source = "./modules/production"
  
  # Pass any required variables here
  external_port = 3000
  project_id = "fileexchangehub"
  server_image      = "rafaelxokito/fileexchangehubserver"
  socket_server_image = "rafaelxokito/fileexchangehubsocketserver"
  client_image       = "rafaelxokito/fileexchangehubclient"
  file_gateway_image       = "rafaelxokito/fileexchangehubfilegateway"
  mongo_connection_string = "mongodb+srv://admin:admin@fileexchangehub.vfybz5q.mongodb.net/test"

  azure_client_id = ""
  azure_client_secret = ""
  azure_subscription_id = "139dfd40-9d71-4ada-a60f-5f0ec09fddd1"
  azure_tenant_id = "536b85ad-a448-4186-a9af-e3ccad3302c5"
}