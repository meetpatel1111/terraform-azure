variable "name" {
  type        = string
  description = "Name of the Virtual Network."
}

variable "location" {
  type        = string
  description = "Azure region where the Virtual Network will be created."
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group name that will contain the Virtual Network."
}

variable "address_space" {
  type        = list(string)
  description = "List of address space CIDRs assigned to the Virtual Network."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the Virtual Network."
  default     = {}
}
