resource "azurerm_key_vault" "kv" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.sku_name

  # Use Azure RBAC instead of access_policies
  rbac_authorization_enabled = true

  purge_protection_enabled      = var.purge_protection_enabled
  soft_delete_retention_days    = var.soft_delete_retention_days
  public_network_access_enabled = true
  tags                          = var.tags
}

# --- RBAC ROLE ASSIGNMENTS ---

# Service Principal running Terraform: full administrative rights on vault
resource "azurerm_role_assignment" "kv_admin" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Needed to create and manage keys (including rotation read/write)
resource "azurerm_role_assignment" "kv_crypto_officer" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Needed to allow getrotationpolicy and avoid 403 during reads
resource "azurerm_role_assignment" "kv_crypto_user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Managed identities (VM, apps) allowed to read secrets
resource "azurerm_role_assignment" "kv_secrets_user" {
  for_each             = toset(var.principal_object_ids)
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = each.value
}

# Wait for RBAC propagation to avoid 403 failures
resource "time_sleep" "wait_for_rbac" {
  depends_on = [
    azurerm_role_assignment.kv_admin,
    azurerm_role_assignment.kv_crypto_officer,
    azurerm_role_assignment.kv_crypto_user,
    azurerm_role_assignment.kv_secrets_user
  ]
  create_duration = "45s"
}

# Store secrets after RBAC is ready
resource "azurerm_key_vault_secret" "secrets" {
  for_each     = var.secrets
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.kv.id
  depends_on   = [time_sleep.wait_for_rbac]
}

# Create RSA key if enabled
resource "azurerm_key_vault_key" "key" {
  count        = var.create_key ? 1 : 0
  name         = var.key_name
  key_vault_id = azurerm_key_vault.kv.id
  key_type     = var.key_type
  key_size     = var.key_size
  key_opts     = ["encrypt", "decrypt", "sign", "verify", "wrapKey", "unwrapKey"]
  depends_on   = [time_sleep.wait_for_rbac]
}
