# Shared MCP platform Terraform root

This root provisions the shared Azure resources that belong to `mcp-platform`:

- resource group (optional; reused when `resource_group_name` is supplied)
- Log Analytics workspace
- Azure Container Apps Environment
- shared Azure Key Vault

It is intended to back a dedicated HCP Terraform workspace such as
`mcp-platform-prod`.

## Usage

Run Terraform from this directory (or set your HCP Terraform workspace working directory to `infra/terraform/platform`):

    terraform init
    terraform apply

Typical variables:

```hcl
subscription_id = "00000000-0000-0000-0000-000000000000"
tenant_id       = "00000000-0000-0000-0000-000000000000"
name            = "mcp-prod"
location        = "northeurope"
```

The outputs from this root are intended to be consumed by app repositories that
create their own Container Apps using the shared `mcp-container-app` module.
