output "resource_group_name" {
  description = "Name of the created Resource Group."
  value       = azurerm_resource_group.rg.name
}

output "vnet_id" {
  description = "ID of the created Virtual Network."
  value       = module.vnet.id
}

output "subnet_ids" {
  description = "Map of subnet keys to their subnet IDs."
  value       = { for k, m in module.subnet : k => m.subnet_id }
}

output "vm_private_ip" {
  description = "Private IP address of the Linux VM NIC."
  value       = module.vm.private_ip
}

output "vm_public_ip" {
  description = "Public IP address of the Linux VM (null if not created)."
  value       = module.vm.public_ip
}

output "storage_account_id" {
  description = "ID of the created Storage Account."
  value       = module.storage.id
}


output "key_vault_uri" {
  description = "Key Vault URI (null if disabled)."
  value       = var.key_vault.enabled ? module.key_vault[0].uri : null
}

output "vm_principal_id" {
  description = "Object ID of the VM's system-assigned managed identity."
  value       = module.vm.principal_id
}
