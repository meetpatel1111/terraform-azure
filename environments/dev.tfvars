prefix      = "demo"
environment = "dev"
location    = "uksouth"
rg_name     = "rg-np-uks-dev"

tags = {
  env   = "dev"
  owner = "platform"
}

address_space = ["10.10.0.0/16"]

subnets = {
  web = {
    address_prefixes = ["10.10.1.0/24"]
    nsg_rules = [
      {
        name                       = "Allow-HTTP"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Allow-SSH"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
  app = {
    address_prefixes = ["10.10.2.0/24"]
    nsg_rules        = []
  }
}

vm = {
  size             = "Standard_B1s"
  admin_username   = "azureuser"
  ssh_public_key   = ""
  subnet_key       = "web"
  create_public_ip = true
  data_disks_gb    = [64]
}

storage = {
  account_tier        = "Standard"
  account_replication = "LRS"
  allow_public_access = false
  containers          = ["logs", "backups"]
}

role_assignments = []


key_vault = {
  enabled  = true
  sku_name = "standard"
}
