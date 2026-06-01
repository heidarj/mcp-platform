module "platform" {
  source = "../modules/mcp-platform"

  name                           = var.name
  location                       = var.location
  tenant_id                      = var.tenant_id
  resource_group_name            = var.resource_group_name
  log_analytics_workspace_name   = var.log_analytics_workspace_name
  container_app_environment_name = var.container_app_environment_name
  key_vault_name                 = var.key_vault_name
  key_vault_bootstrap_principal_ids = var.key_vault_bootstrap_principal_ids
  tags                           = var.tags
}
