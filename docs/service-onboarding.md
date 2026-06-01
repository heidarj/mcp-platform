# Onboarding a new MCP service

Use this flow when bringing a new MCP app onto the shared platform.

1. Create the app repository.
2. Create a dedicated HCP Terraform workspace for the app.
3. Create or reuse Azure federated credentials for the app repository.
4. Add a thin app Terraform root that consumes the shared
   `mcp-container-app` module.
5. Reference the shared platform outputs from the `mcp-platform-prod`
   workspace.
6. Create the app-specific Key Vault secrets in the shared Key Vault.
7. Grant the app Container App managed identity permission to read only the
   required secrets.
8. Add minimal GitHub workflow wrappers that call the reusable workflows in
   `heidarj/mcp-platform`.
9. Deploy.

## Thin app Terraform shape

App repositories should keep their own Terraform state and create only their
own Container App and RBAC wiring.

```hcl
data "terraform_remote_state" "platform" {
  backend = "remote"

  config = {
    organization = var.tf_backend_organization
    workspaces = {
      name = "mcp-platform-prod"
    }
  }
}

module "service" {
  source = "git::https://github.com/heidarj/mcp-platform.git//infra/terraform/modules/mcp-container-app?ref=main"

  name                         = "ca-kronan-mcp-api"
  resource_group_name          = data.terraform_remote_state.platform.outputs.resource_group_name
  location                     = data.terraform_remote_state.platform.outputs.location
  container_app_environment_id = data.terraform_remote_state.platform.outputs.container_app_environment_id
  image                        = "ghcr.io/heidarj/kronan.mcpar.is:main"

  env_vars = {
    ASPNETCORE_HTTP_PORTS = "8080"
  }

  key_vault_secret_refs = {
    KRONAN_API_KEY = {
      key_vault_secret_id = data.azurerm_key_vault_secret.kronan_api_key.versionless_id
    }
    MCP_SERVER_API_KEY = {
      key_vault_secret_id = data.azurerm_key_vault_secret.mcp_server_api_key.versionless_id
    }
  }
}
```

Reusable workflows continue to run in the caller repository context, so each
app repository must have its own OIDC subjects and GitHub environment setup.
