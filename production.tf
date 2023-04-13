module "production" {
  source = "./modules/production"
  
  # Pass any required variables here
  external_port = 3000
  project_id = "fileexchangehub"
  server_image      = "rafaelxokito/fileexchangehubserver"
  socket_server_image = "rafaelxokito/fileexchangehubsocketserver"
  client_image       = "rafaelxokito/fileexchangehubclient"
  mongo_connection_string = "mongodb+srv://admin:admin@fileexchangehub.vfybz5q.mongodb.net/test"
}