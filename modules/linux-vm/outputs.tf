output "id" {
  description = "ID of the Linux Virtual Machine."
  value       = azurerm_linux_virtual_machine.vm.id
}

output "private_ip" {
  description = "Private IP address of the VM."
  value       = azurerm_network_interface.nic.ip_configuration[0].private_ip_address
}

output "public_ip" {
  description = "Public IP address of the VM (null if not created)."
  value       = try(azurerm_public_ip.pip[0].ip_address, null)
}
