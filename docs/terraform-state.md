# Terraform workspace boundaries

Use separate HCP Terraform workspaces for shared platform resources and each
independent MCP service.

## Recommended workspaces

### `mcp-platform-prod`

Owns shared platform resources only:

- shared resource group, when created here
- shared Log Analytics workspace
- shared Azure Container Apps Environment
- shared Key Vault

### `kronan-mcpar-is-prod`

Owns Kronan resources only:

- Kronan Container App
- Kronan managed identity RBAC for required secrets
- Kronan-specific environment variable wiring

### `outlook-mcpar-is-prod`

Owns Outlook resources only:

- Outlook Container App
- Outlook managed identity RBAC for required secrets
- Outlook-specific environment variable wiring

## Boundary rules

- Do not store app resources in `mcp-platform-prod`.
- Do not reuse one app repository workspace for another app.
- Do not make one app repository the owner of the shared Container Apps
  Environment or shared Key Vault.
