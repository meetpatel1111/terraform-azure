prefix      = "prod"
environment = "prod"
location    = "uksouth"
rg_name     = "rg-p-uks-prod"

tags = { env = "prod", owner = "platform" }

address_space = ["10.30.0.0/16"]

subnets = {
  web = { address_prefixes = ["10.30.10.0/24"], nsg_rules = [] }
  app = { address_prefixes = ["10.30.20.0/24"], nsg_rules = [] }
  db  = { address_prefixes = ["10.30.30.0/24"], nsg_rules = [] }
}

vm = {
  size             = "Standard_D2s_v5"
  admin_username   = "azureuser"
  ssh_public_key   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCEXAMPLEYOURKEYONLY"
  subnet_key       = "app"
  create_public_ip = false
  data_disks_gb    = [128, 128]
}

storage = {
  account_tier        = "Premium"
  account_replication = "ZRS"
  allow_public_access = false
  containers          = ["data", "logs", "exports"]
}

# Example IAM
role_assignments = [
  # {
  #   principal_id         = "00000000-0000-0000-0000-000000000000"
  #   role_definition_name = "Reader"
  #   scope_level          = "resource_group"
  # }
]
