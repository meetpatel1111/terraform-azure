variable "principal_id" {
  type        = string
  description = "Object ID of the principal (user, group, or service principal) for the role assignment."
}

variable "role_name" {
  type        = string
  description = "Built-in or custom role definition name (e.g. Reader, Contributor)."
}

variable "scope_level" {
  type        = string
  description = "Scope level for the role assignment: subscription, resource_group, or resource."
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID used when scope_level is subscription."
}

variable "resource_group_id" {
  type        = string
  description = "Resource Group ID used when scope_level is resource_group."
}

variable "resource_id" {
  type        = string
  description = "Target resource ID used when scope_level is resource."
  default     = null
}
