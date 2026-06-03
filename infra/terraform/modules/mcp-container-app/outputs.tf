output "container_app_id" {
  description = "Resource ID of the Azure Container App."
  value       = azurerm_container_app.this.id
}

output "container_app_name" {
  description = "Name of the Azure Container App."
  value       = azurerm_container_app.this.name
}

output "container_app_fqdn" {
  description = "Public FQDN of the Container App ingress."
  value       = azurerm_container_app.this.ingress[0].fqdn
}

output "container_app_url" {
  description = "HTTPS URL of the Container App ingress."
  value       = "https://${azurerm_container_app.this.ingress[0].fqdn}"
}

output "principal_id" {
  description = "System-assigned managed identity principal ID for Key Vault RBAC."
  value       = azurerm_container_app.this.identity[0].principal_id
}
