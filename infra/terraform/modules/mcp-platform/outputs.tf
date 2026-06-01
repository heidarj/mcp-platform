output "resource_group_name" {
  description = "Name of the shared resource group."
  value       = local.resource_group_name
}

output "location" {
  description = "Azure region used by the shared platform."
  value       = var.location
}

output "container_app_environment_id" {
  description = "Resource ID of the shared Container Apps Environment."
  value       = azurerm_container_app_environment.main.id
}

output "container_app_environment_name" {
  description = "Name of the shared Container Apps Environment."
  value       = azurerm_container_app_environment.main.name
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the shared Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.main.id
}

output "key_vault_id" {
  description = "Resource ID of the shared Key Vault."
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Name of the shared Key Vault."
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI of the shared Key Vault."
  value       = azurerm_key_vault.main.vault_uri
}
