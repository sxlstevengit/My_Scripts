data_dir = "/opt/consul"
client_addr = "0.0.0.0"
ui_config{
  enabled = true
}
server = true
advertise_addr = "192.168.111.131"
bootstrap_expect=1
 
acl = {
  enabled = true
  default_policy = "deny"
  enable_token_persistence = true
}