output "id" {
  description = "ID of the Storage Account."
  value       = azurerm_storage_account.sa.id
}

output "name" {
  description = "Name of the Storage Account."
  value       = azurerm_storage_account.sa.name
}

output "primary_endpoint" {
  description = "Primary blob service endpoint of the Storage Account."
  value       = azurerm_storage_account.sa.primary_blob_endpoint
}
