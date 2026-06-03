# Shared platform IaC ownership

`mcp-platform` owns the shared Azure infrastructure used by MCP services.

## What `mcp-platform` owns

- shared resource group, when one is not supplied externally
- shared Log Analytics workspace
- shared Azure Container Apps Environment
- shared Azure Key Vault
- shared Terraform modules and reusable workflow contracts

The shared Terraform root is `infra/terraform/platform`.

Its outputs are intended to be consumed by app repositories:

- `resource_group_name`
- `location`
- `container_app_environment_id`
- `container_app_environment_name`
- `log_analytics_workspace_id`
- `key_vault_id`
- `key_vault_name`
- `key_vault_uri`

## What `mcp-platform` does not own

- application source code
- app-specific Azure Container Apps
- app-specific runtime configuration
- app-specific Terraform state
- app-specific secret values

Each MCP service repository should keep a thin Terraform root that consumes the
shared outputs and creates exactly one service-specific Container App.
