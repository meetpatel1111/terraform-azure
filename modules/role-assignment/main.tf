locals {
  scope = (
    var.scope_level == "subscription" ? "/subscriptions/${var.subscription_id}" :
    var.scope_level == "resource_group" ? var.resource_group_id :
    var.resource_id
  )
}

resource "azurerm_role_assignment" "this" {
  scope                = local.scope
  role_definition_name = var.role_name
  principal_id         = var.principal_id
}
