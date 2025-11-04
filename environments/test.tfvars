prefix      = "demo"
environment = "test"
location    = "uksouth"
rg_name     = "rg-np-uks-test"

tags = { env = "test" }

address_space = ["10.20.0.0/16"]

subnets = {
  app = { address_prefixes = ["10.20.1.0/24"], nsg_rules = [] }
  db  = { address_prefixes = ["10.20.2.0/24"], nsg_rules = [] }
}

vm = {
  size             = "Standard_B1s"
  admin_username   = "azureuser"
  ssh_public_key   = ""
  subnet_key       = "app"
  create_public_ip = false
  data_disks_gb    = []
}

storage = {
  account_tier        = "Standard"
  account_replication = "GRS"
  allow_public_access = false
  containers          = ["artifacts"]
}

role_assignments = []
