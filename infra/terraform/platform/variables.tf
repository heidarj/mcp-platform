variable "subscription_id" {
  description = "Azure subscription ID that owns the shared MCP platform resources."
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID used for the shared Key Vault."
  type        = string
}

variable "name" {
  description = "Short shared platform name used in default resource names."
  type        = string
  default     = "mcp-prod"
}

variable "location" {
  description = "Azure region for the shared MCP platform."
  type        = string
  default     = "northeurope"
}

variable "resource_group_name" {
  description = "Existing resource group name to reuse. Leave null to create a shared resource group."
  type        = string
  default     = null
}

variable "log_analytics_workspace_name" {
  description = "Override for the shared Log Analytics workspace name."
  type        = string
  default     = null
}

variable "container_app_environment_name" {
  description = "Override for the shared Container Apps Environment name."
  type        = string
  default     = null
}

variable "key_vault_name" {
  description = "Override for the shared Key Vault name. Must be globally unique."
  type        = string
  default     = null
}

variable "key_vault_bootstrap_principal_ids" {
  description = "Azure object IDs that should receive bootstrap Key Vault secret management access."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags applied to shared platform resources."
  type        = map(string)
  default     = {}
}
