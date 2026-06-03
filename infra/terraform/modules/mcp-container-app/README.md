# `mcp-container-app` Terraform module

Creates exactly one Azure Container App for a single MCP service.

This module does **not** create:

- the shared Container Apps Environment
- the shared Key Vault
- shared platform state

Those are expected to come from `infra/terraform/platform` outputs.

## Required inputs

- `name`
- `resource_group_name`
- `container_app_environment_id`
- `image`
- `target_port`
- `cpu`
- `memory`
- `min_replicas`
- `max_replicas`
- `env_vars`
- `secret_env_vars`
- `key_vault_secret_refs`
- `tags`

## Optional inputs

- `location` — Azure region. Accepted to align with shared platform outputs but not used by this module (`default = null`).

## Defaults

- `target_port = 8080`
- `cpu = 0.25`
- `memory = "0.5Gi"`
- `min_replicas = 0`
- `max_replicas = 3`

## Notes

- External HTTP ingress is enabled.
- The module creates a system-assigned managed identity and outputs its
  `principal_id` so the caller can grant `Key Vault Secrets User` on only the
  required secrets.
- `key_vault_secret_refs` is the preferred runtime secret path.
- `secret_env_vars` exists for bootstrap-only cases where a value must be stored
  directly on the Container App.
- The container image field is ignored after first apply so a GitHub Actions
  deploy workflow can update image revisions without Terraform fighting it.
- Optional `registry` input supports private GHCR images when credentials are
  required.
