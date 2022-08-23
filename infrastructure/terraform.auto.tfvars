region                     = "us-west-2"
hcp_region                 = "us-west-2"
key_pair_name              = "nkabar"
name                       = "lynx"
hcp_consul_public_endpoint = true
hcp_vault_public_endpoint  = true

tags = {
  Environment = "nkabar-hashicorp-stack-demoapp"
  Automation  = "terraform"
  Owner       = "nkabar"
}
