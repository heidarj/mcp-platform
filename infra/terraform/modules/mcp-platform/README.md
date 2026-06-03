# `mcp-platform` Terraform module

Creates the shared Azure foundation for MCP services:

- resource group (optional)
- Log Analytics workspace
- Azure Container Apps Environment
- shared Azure Key Vault with Azure RBAC enabled

## Inputs

- `name` — shared platform name such as `mcp-prod`
- `location` — Azure region
- `tenant_id` — tenant that owns the Key Vault
- `resource_group_name` — optional existing resource group name
- `key_vault_bootstrap_principal_ids` — optional Azure object IDs that should
  receive bootstrap secret-management access
- `tags` — extra tags

## Outputs

- `resource_group_name`
- `location`
- `container_app_environment_id`
- `container_app_environment_name`
- `log_analytics_workspace_id`
- `key_vault_id`
- `key_vault_name`
- `key_vault_uri`

The module intentionally does not create any application-specific Container
Apps. Consuming repositories should use the shared outputs to deploy one app
per repository in separate Terraform state.
