variable "name" {
  description = "Short shared platform name used in default resource names."
  type        = string
}

variable "location" {
  description = "Azure region for the shared platform."
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID used by the shared Key Vault."
  type        = string
}

variable "resource_group_name" {
  description = "Existing resource group name to reuse. Leave null to create one."
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

variable "key_vault_bootstrap_role_definition_name" {
  description = "RBAC role assigned to bootstrap principals on the shared Key Vault."
  type        = string
  default     = "Key Vault Secrets Officer"
}

variable "log_analytics_workspace_sku" {
  description = "SKU for the shared Log Analytics workspace."
  type        = string
  default     = "PerGB2018"
}

variable "log_analytics_workspace_retention_in_days" {
  description = "Retention period for shared Container Apps logs."
  type        = number
  default     = 30
}

variable "key_vault_purge_protection_enabled" {
  description = "Whether purge protection is enabled for the shared Key Vault."
  type        = bool
  default     = true
}

variable "key_vault_soft_delete_retention_days" {
  description = "Soft delete retention period for the shared Key Vault."
  type        = number
  default     = 90
}

variable "tags" {
  description = "Additional tags applied to shared platform resources."
  type        = map(string)
  default     = {}
}
