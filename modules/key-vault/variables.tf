variable "name" {
  type        = string
  description = "Name of the Key Vault."
}

variable "location" {
  type        = string
  description = "Azure region for the Key Vault."
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group name where the Key Vault will be created."
}

variable "sku_name" {
  type        = string
  description = "SKU of the Key Vault (standard or premium)."
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Whether to enable purge protection."
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Soft delete retention in days."
}

variable "secrets" {
  type        = map(string)
  description = "Map of secret name -> value to create in the Key Vault."
  default     = {}
}

variable "create_key" {
  type        = bool
  description = "Whether to create a cryptographic key in the Key Vault."
  default     = false
}

variable "key_name" {
  type        = string
  description = "Name of the key to create (if create_key=true)."
  default     = "platform-key"
}

variable "key_type" {
  type        = string
  description = "Key type (e.g., RSA, EC)."
  default     = "RSA"
}

variable "key_size" {
  type        = number
  description = "Key size in bits (e.g., 2048 for RSA)."
  default     = 2048
}

variable "principal_object_ids" {
  type        = list(string)
  default     = []
  description = "List of principal object IDs to grant Key Vault access."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the Key Vault."
  default     = {}
}
