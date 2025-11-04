variable "prefix" {
  type        = string
  description = "Optional application or business prefix for tagging and metadata only."
  default     = ""
}

variable "environment" {
  type        = string
  description = "Name of the environment (e.g. dev, test, prod)."
}

variable "location" {
  type        = string
  description = "Azure region where resources will be deployed (e.g. uksouth, eastus)."
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply to all resources."
  default     = {}
}

variable "rg_name" {
  type        = string
  description = "Name of the Azure Resource Group to create."
}

variable "address_space" {
  type        = list(string)
  description = "Address space CIDRs for the Virtual Network (e.g. ['10.10.0.0/16'])."
}

variable "subnets" {
  description = "Map of subnets to deploy. Keys become subnet suffixes; values define prefixes and NSG rules."
  type = map(object({
    address_prefixes = list(string)
    nsg_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })), [])
  }))
}

variable "vm" {
  description = "Linux VM configuration from the consumer's perspective."
  type = object({
    size             = string
    admin_username   = string
    ssh_public_key   = string
    subnet_key       = string
    create_public_ip = bool
    data_disks_gb    = optional(list(number), [])
    identity_enabled = optional(bool, true)
    image = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }), null)
  })
}

variable "storage" {
  description = "Storage account configuration from the consumer's perspective."
  type = object({
    account_tier        = string
    account_replication = string
    allow_public_access = optional(bool, false)
    containers          = optional(list(string), [])
  })
}

variable "role_assignments" {
  description = "List of IAM role assignments to create at subscription, resource group, or resource scope."
  type = list(object({
    principal_id         = string
    role_definition_name = string
    scope_level          = string # subscription | resource_group | resource
    resource_id          = optional(string)
  }))
  default = []
}
