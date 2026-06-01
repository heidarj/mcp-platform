output "resource_group_name" {
  description = "Name of the shared resource group."
  value       = module.platform.resource_group_name
}

output "location" {
  description = "Azure region used by the shared platform."
  value       = module.platform.location
}

output "container_app_environment_id" {
  description = "Resource ID of the shared Azure Container Apps Environment."
  value       = module.platform.container_app_environment_id
}

output "container_app_environment_name" {
  description = "Name of the shared Azure Container Apps Environment."
  value       = module.platform.container_app_environment_name
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the shared Log Analytics workspace."
  value       = module.platform.log_analytics_workspace_id
}

output "key_vault_id" {
  description = "Resource ID of the shared Key Vault."
  value       = module.platform.key_vault_id
}

output "key_vault_name" {
  description = "Name of the shared Key Vault."
  value       = module.platform.key_vault_name
}

output "key_vault_uri" {
  description = "URI of the shared Key Vault."
  value       = module.platform.key_vault_uri
}
