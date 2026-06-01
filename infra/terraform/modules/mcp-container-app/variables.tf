variable "name" {
  description = "Name of the Azure Container App."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group that already contains the shared Container Apps Environment."
  type        = string
}

variable "location" {
  description = "Azure region for the service. Included to align with shared platform outputs."
  type        = string
}

variable "container_app_environment_id" {
  description = "Resource ID of the shared Azure Container Apps Environment."
  type        = string
}

variable "image" {
  description = "Fully qualified container image reference."
  type        = string
}

variable "target_port" {
  description = "Ingress target port exposed by the service."
  type        = number
  default     = 8080
}

variable "cpu" {
  description = "CPU allocated to the container."
  type        = number
  default     = 0.25
}

variable "memory" {
  description = "Memory allocated to the container."
  type        = string
  default     = "0.5Gi"
}

variable "min_replicas" {
  description = "Minimum number of replicas."
  type        = number
  default     = 0
}

variable "max_replicas" {
  description = "Maximum number of replicas."
  type        = number
  default     = 3
}

variable "env_vars" {
  description = "Plain environment variables passed directly to the container."
  type        = map(string)
  default     = {}
}

variable "secret_env_vars" {
  description = "Secret values stored directly on the Container App. Prefer Key Vault references when possible."
  type        = map(string)
  default     = {}
}

variable "key_vault_secret_refs" {
  description = "Map of environment variable name to Key Vault-backed Container App secret configuration."
  type = map(object({
    key_vault_secret_id = string
    secret_name         = optional(string)
  }))
  default = {}
}

variable "registry" {
  description = "Optional private registry configuration, including GHCR credentials when required."
  type = object({
    server                              = string
    username                            = string
    password_secret_name                = string
    password_secret_value               = optional(string)
    password_secret_key_vault_secret_id = optional(string)
    identity                            = optional(string)
  })
  default = null

  validation {
    condition = var.registry == null || (
      (try(var.registry.password_secret_value, null) != null) !=
      (try(var.registry.password_secret_key_vault_secret_id, null) != null)
    )
    error_message = "registry must define exactly one of password_secret_value or password_secret_key_vault_secret_id."
  }
}

variable "tags" {
  description = "Tags applied to the Container App."
  type        = map(string)
  default     = {}
}
