output "subnet_id" {
  description = "ID of the created Subnet."
  value       = azurerm_subnet.subnet.id
}

output "nsg_id" {
  description = "ID of the Network Security Group associated with the Subnet."
  value       = azurerm_network_security_group.nsg.id
}
