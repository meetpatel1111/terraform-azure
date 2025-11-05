###########################
# Key Vault Module
###########################

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.sku_name

  rbac_authorization_enabled = true

  purge_protection_enabled      = var.purge_protection_enabled
  soft_delete_retention_days    = var.soft_delete_retention_days
  public_network_access_enabled = true
  tags                          = var.tags
}

###########################
# RBAC assignments for Terraform principal
###########################

resource "azurerm_role_assignment" "kv_admin" {
  scope                            = azurerm_key_vault.kv.id
  role_definition_name             = "Key Vault Administrator"
  principal_id                     = data.azurerm_client_config.current.object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "kv_crypto_officer" {
  scope                            = azurerm_key_vault.kv.id
  role_definition_name             = "Key Vault Crypto Officer"
  principal_id                     = data.azurerm_client_config.current.object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "kv_crypto_user" {
  scope                            = azurerm_key_vault.kv.id
  role_definition_name             = "Key Vault Crypto User"
  principal_id                     = data.azurerm_client_config.current.object_id
  skip_service_principal_aad_check = true
}

###########################
# Managed identity permissions for secrets
###########################

# FIX: Deterministic for_each keys so Terraform can plan
locals {
  principal_map = {
    for idx in range(length(var.principal_object_ids)) :
    tostring(idx) => var.principal_object_ids[idx]
  }
}

resource "azurerm_role_assignment" "kv_secrets_user" {
  for_each                         = local.principal_map
  scope                            = azurerm_key_vault.kv.id
  role_definition_name             = "Key Vault Secrets User"
  principal_id                     = each.value
  skip_service_principal_aad_check = true
}

###########################
# Wait for RBAC propagation
###########################

resource "time_sleep" "wait_for_rbac" {
  depends_on = [
    azurerm_role_assignment.kv_admin,
    azurerm_role_assignment.kv_crypto_officer,
    azurerm_role_assignment.kv_crypto_user,
    azurerm_role_assignment.kv_secrets_user
  ]
  create_duration = "45s"
}

###########################
# Store secrets
###########################

resource "azurerm_key_vault_secret" "secrets" {
  for_each     = var.secrets
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.kv.id
  depends_on   = [time_sleep.wait_for_rbac]
}

###########################
# Optional Key Creation
###########################

resource "azurerm_key_vault_key" "key" {
  count        = var.create_key ? 1 : 0
  name         = var.key_name
  key_vault_id = azurerm_key_vault.kv.id
  key_type     = var.key_type
  key_size     = var.key_size
  key_opts     = ["encrypt", "decrypt", "sign", "verify", "wrapKey", "unwrapKey"]

  rotation_policy {
    expire_after         = "P365D"
    notify_before_expiry = "P30D"
    automatic {
      time_before_expiry = "P30D"
    }
  }

  depends_on = [time_sleep.wait_for_rbac]
}
