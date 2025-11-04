variable "name" {
  type        = string
  description = "Name of the Subnet (module consumer provides full name)."
}

variable "location" {
  type        = string
  description = "Azure region where the Subnet and NSG will be created."
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group name that will contain the Subnet and NSG."
}

variable "vnet_name" {
  type        = string
  description = "Name of the Virtual Network in which to create the Subnet."
}

variable "address_prefixes" {
  type        = list(string)
  description = "List of address prefixes (CIDRs) for the Subnet."
}

variable "nsg_rules" {
  description = "Optional list of NSG rules to create and associate with the Subnet."
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the NSG."
  default     = {}
}
