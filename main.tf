resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
  tags     = merge(var.tags, { environment = var.environment })
}

module "vnet" {
  source              = "./modules/vnet"
  name                = local.name.vnet
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.address_space
  tags                = var.tags
}

module "subnet" {
  for_each            = var.subnets
  source              = "./modules/subnet"
  name                = "${local.name.subnet}-${each.key}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  vnet_name           = module.vnet.name
  address_prefixes    = each.value.address_prefixes
  nsg_rules           = each.value.nsg_rules
  tags                = var.tags
}

module "storage" {
  source              = "./modules/storage-account"
  name                = local.storage_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  account_tier        = var.storage.account_tier
  account_replication = var.storage.account_replication
  allow_public_access = var.storage.allow_public_access
  containers          = var.storage.containers
  tags                = var.tags
}

module "vm" {
  source              = "./modules/linux-vm"
  name                = "${local.name.vm}-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.subnet[var.vm.subnet_key].subnet_id
  size                = var.vm.size
  admin_username      = var.vm.admin_username
  ssh_public_key      = var.vm.ssh_public_key
  create_public_ip    = var.vm.create_public_ip
  data_disks_gb       = var.vm.data_disks_gb
  identity_enabled    = var.vm.identity_enabled
  image               = var.vm.image
  nic_name            = "${local.name.nic}-01"
  pip_name            = "${local.name.pip}-01"
  tags                = var.tags
}

module "iam" {
  source            = "./modules/role-assignment"
  for_each          = { for i, ra in var.role_assignments : i => ra }
  principal_id      = each.value.principal_id
  role_name         = each.value.role_definition_name
  scope_level       = each.value.scope_level
  subscription_id   = data.azurerm_client_config.current.subscription_id
  resource_group_id = azurerm_resource_group.rg.id
  resource_id       = try(each.value.resource_id, null)
}
