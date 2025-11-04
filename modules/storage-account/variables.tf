variable "name" {
  type        = string
  description = "Name of the Storage Account (must be globally unique, 3-24 lowercase alphanumeric)."
}

variable "location" {
  type        = string
  description = "Azure region where the Storage Account will be created."
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group name that will contain the Storage Account."
}

variable "account_tier" {
  type        = string
  description = "Storage Account performance tier (e.g. Standard, Premium)."
}

variable "account_replication" {
  type        = string
  description = "Replication type (e.g. LRS, GRS, ZRS)."
}

variable "allow_public_access" {
  type        = bool
  description = "Whether to allow public access to nested items (containers/blobs)."
  default     = false
}

variable "containers" {
  type        = list(string)
  description = "List of blob containers to create."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the Storage Account."
  default     = {}
}
