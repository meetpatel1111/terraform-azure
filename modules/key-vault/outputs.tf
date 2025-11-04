output "id" {
  description = "ID of the Key Vault."
  value       = azurerm_key_vault.kv.id
}

output "name" {
  description = "Name of the Key Vault."
  value       = azurerm_key_vault.kv.name
}

output "uri" {
  description = "Vault URI endpoint."
  value       = azurerm_key_vault.kv.vault_uri
}
