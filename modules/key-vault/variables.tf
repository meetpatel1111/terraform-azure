variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "standard"
}

variable "purge_protection_enabled" {
  type    = bool
  default = true
}

variable "soft_delete_retention_days" {
  type    = number
  default = 7
}

variable "secrets" {
  type = map(string)
}

variable "create_key" {
  type    = bool
  default = false
}

variable "key_name" {
  type    = string
  default = null
}

variable "key_type" {
  type    = string
  default = "RSA"
}

variable "key_size" {
  type    = number
  default = 2048
}

# ✅ ensure list input is known length at plan time
variable "principal_object_ids" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}
