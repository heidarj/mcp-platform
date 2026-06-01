# Onboarding a new MCP service

Use this checklist when bringing a new MCP service repository onto the shared platform.

## New MCP service checklist

1. Create the application repository.
2. Create the HCP Terraform workspace.
3. Configure GitHub repository variables.
4. Configure GitHub repository secrets.
5. Create Azure OIDC federated credentials.
6. Create the production environment.
7. Call the reusable workflows from `heidarj/mcp-platform` with `secrets: inherit`.

## Required repository variables

- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `GHCR_USERNAME`
- `CONTAINER_APP_NAME`
- `RESOURCE_GROUP_NAME`
- `TF_BACKEND_HOSTNAME`
- `TF_BACKEND_ORGANIZATION`
- `TF_BACKEND_WORKSPACE`

## Typical repository secrets

- `TF_API_TOKEN`
- `GHCR_PAT`

Application-specific secrets should preferably be stored in Azure Key Vault and consumed by Azure Container Apps through managed identities.

## Minimal caller workflow example

```yaml
name: deploy

on:
  push:
    branches:
      - main
  pull_request:

jobs:
  validate:
    uses: heidarj/mcp-platform/.github/workflows/terraform-validate.yml@main
    with:
      terraform_directory: ./terraform
    secrets: inherit

  plan:
    if: github.event_name == 'pull_request'
    needs: validate
    uses: heidarj/mcp-platform/.github/workflows/terraform-plan.yml@main
    with:
      terraform_directory: ./terraform
      workspace_name: ${{ vars.TF_BACKEND_WORKSPACE }}
    secrets: inherit

  build:
    if: github.ref == 'refs/heads/main'
    uses: heidarj/mcp-platform/.github/workflows/build-container.yml@main
    with:
      image_name: kronan.mcpar.is
      dotnet_version: 9.0.x
      dockerfile_path: ./Dockerfile
      context_path: .
      run_tests: true
    secrets: inherit

  deploy:
    if: github.ref == 'refs/heads/main'
    needs: build
    uses: heidarj/mcp-platform/.github/workflows/deploy-container-app.yml@main
    with:
      container_app_name: ${{ vars.CONTAINER_APP_NAME }}
      resource_group_name: ${{ vars.RESOURCE_GROUP_NAME }}
      image: ${{ needs.build.outputs.image }}
    secrets: inherit

  apply:
    if: github.ref == 'refs/heads/main'
    needs: deploy
    uses: heidarj/mcp-platform/.github/workflows/terraform-apply.yml@main
    with:
      terraform_directory: ./terraform
      workspace_name: ${{ vars.TF_BACKEND_WORKSPACE }}
    secrets: inherit
```
