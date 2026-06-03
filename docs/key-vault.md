# Shared Key Vault guidance

`mcp-platform` creates one shared Azure Key Vault for MCP service runtime
secrets. The Key Vault exists to hold values such as:

- `KRONAN_API_KEY`
- `MCP_SERVER_API_KEY`
- future Outlook / Graph secrets

## Secret naming

Use stable, service-specific secret names so ownership stays obvious, for
example:

- `kronan-api-key`
- `kronan-mcp-server-api-key`
- `outlook-graph-client-secret`

Environment variable names inside a Container App can still be
`KRONAN_API_KEY` or `MCP_SERVER_API_KEY`; the Terraform module maps those env
vars to Key Vault-backed Container App secrets.

## How secrets should be created

Preferred bootstrap path:

1. Apply the shared platform Terraform to create the Key Vault.
2. Grant a bootstrap operator or CI principal `Key Vault Secrets Officer` on
   the shared Key Vault.
3. Create secret values outside Terraform with `az keyvault secret set`, the
   Azure portal, or a dedicated secret-bootstrap process.
4. In the app repository Terraform, look up the secret and wire it into the
   Container App via `key_vault_secret_refs`.

## How Container Apps should read secrets

1. The app repository creates one Container App with a managed identity.
2. The app repository grants that identity `Key Vault Secrets User` on only the
   required secrets or the smallest acceptable Key Vault scope.
3. Container App environment variables reference Key Vault-backed secrets.

This avoids Azure client secrets and keeps runtime access aligned with managed
identity.

## RBAC roles

Recommended roles:

- bootstrap operator / CI principal: `Key Vault Secrets Officer`
- Container App managed identity: `Key Vault Secrets User`

Use Azure RBAC on the Key Vault rather than legacy access policies unless a
specific legacy constraint requires otherwise.

## Why secret values should not live in Terraform state

Terraform state is durable and widely accessible compared with runtime secret
stores. Storing real secret values in state increases the blast radius of a
state leak and makes secret rotation harder to reason about.

`secret_env_vars` in the shared `mcp-container-app` module exists only as a
bootstrap path. The default and recommended pattern is to create secrets in Key
Vault first, then use managed identity plus `key_vault_secret_refs`.
