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

# Service Principal running Terraform: full administrative rights on vault
resource "azurerm_role_assignment" "kv_admin" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
  skip_service_principal_aad_check = true
}

# Needed to create and manage keys
resource "azurerm_role_assignment" "kv_crypto_officer" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = data.azurerm_client_config.current.object_id
  skip_service_principal_aad_check = true
}

# Needed to avoid 403 when reading key rotation policy
resource "azurerm_role_assignment" "kv_crypto_user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = data.azurerm_client_config.current.object_id
  skip_service_principal_aad_check = true
}

# Managed identities allowed to read secrets
resource "azurerm_role_assignment" "kv_secrets_user" {
  for_each             = toset(var.principal_object_ids)
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = each.value
  skip_service_principal_aad_check = true
}

# Wait for RBAC propagation
resource "time_sleep" "wait_for_rbac" {
  depends_on = [
    azurerm_role_assignment.kv_admin,
    azurerm_role_assignment.kv_crypto_officer,
    azurerm_role_assignment.kv_crypto_user,
    azurerm_role_assignment.kv_secrets_user
  ]
  create_duration = "45s"
}

# Save secrets only after RBAC is active
resource "azurerm_key_vault_secret" "secrets" {
  for_each     = var.secrets
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.kv.id
  depends_on   = [time_sleep.wait_for_rbac]
}

# Create RSA key after RBAC is active
resource "azurerm_key_vault_key" "key" {
  count        = var.create_key ? 1 : 0
  name         = var.key_name
  key_vault_id = azurerm_key_vault.kv.id
  key_type     = var.key_type
  key_size     = var.key_size
  key_opts     = ["encrypt", "decrypt", "sign", "verify", "wrapKey", "unwrapKey"]

  # Valid rotation policy (ISO-8601 durations)
  rotation_policy {
    expire_after = "P365D"   # key expires after 365 days
    automatic {
      time_before_expiry = "P30D"  # rotate 30 days before expiry
    }
  }

  depends_on = [time_sleep.wait_for_rbac]
}
