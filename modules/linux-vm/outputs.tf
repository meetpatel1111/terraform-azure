output "id" {
  description = "ID of the Linux Virtual Machine."
  value       = azurerm_linux_virtual_machine.vm.id
}

output "private_ip" {
  description = "Private IP address of the VM."
  value       = azurerm_network_interface.nic.ip_configuration[0].private_ip_address
}

# Safe without try(): only evaluates the true branch, so it won't index when count=0
output "public_ip" {
  description = "Public IP address of the VM (null if not created)."
  value       = var.create_public_ip ? azurerm_public_ip.pip[0].ip_address : null
}


output "principal_id" {
  description = "Object ID of the VM's system-assigned managed identity."
  value       = azurerm_linux_virtual_machine.vm.identity[0].principal_id
}
