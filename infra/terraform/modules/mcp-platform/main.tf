locals {
  name_prefix = replace(replace(lower(var.name), ".", "-"), "_", "-")

  resource_group_name            = coalesce(var.resource_group_name, "rg-${local.name_prefix}")
  log_analytics_workspace_name   = coalesce(var.log_analytics_workspace_name, "log-${local.name_prefix}")
  container_app_environment_name = coalesce(var.container_app_environment_name, "cae-${local.name_prefix}")
  key_vault_name                 = coalesce(var.key_vault_name, "kv-${substr(local.name_prefix, 0, 15)}-${random_string.key_vault_suffix.result}")

  tags = merge(
    {
      managed_by = "terraform"
      platform   = var.name
    },
    var.tags,
  )
}

resource "random_string" "key_vault_suffix" {
  length  = 5
  upper   = false
  special = false
}

resource "azurerm_resource_group" "main" {
  count = var.resource_group_name == null ? 1 : 0

  name     = local.resource_group_name
  location = var.location
  tags     = local.tags
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = local.log_analytics_workspace_name
  location            = var.location
  resource_group_name = local.resource_group_name
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_analytics_workspace_retention_in_days
  tags                = local.tags
}

resource "azurerm_container_app_environment" "main" {
  name                       = local.container_app_environment_name
  location                   = var.location
  resource_group_name        = local.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  tags                       = local.tags
}

resource "azurerm_key_vault" "main" {
  name                       = local.key_vault_name
  location                   = var.location
  resource_group_name        = local.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
  purge_protection_enabled   = var.key_vault_purge_protection_enabled
  soft_delete_retention_days = var.key_vault_soft_delete_retention_days
  tags                       = local.tags
}

resource "azurerm_role_assignment" "key_vault_bootstrap" {
  for_each = toset(var.key_vault_bootstrap_principal_ids)

  scope                = azurerm_key_vault.main.id
  role_definition_name = var.key_vault_bootstrap_role_definition_name
  principal_id         = each.value
}
