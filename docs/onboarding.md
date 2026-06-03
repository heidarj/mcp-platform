# Onboarding a new MCP service

Use this checklist when bringing a new MCP service repository onto the shared platform.

For the platform/app Terraform split and Key Vault conventions, see:

- `docs/service-onboarding.md`
- `docs/platform-iac.md`
- `docs/key-vault.md`

## New MCP service checklist

1. Create the application repository.
2. Create the HCP Terraform workspace.
3. Configure GitHub repository variables.
4. Configure GitHub repository secrets.
5. Create Azure OIDC federated credentials.
6. Create the production environment.
7. Call the reusable workflows from `heidarj/mcp-platform` with explicit secret mapping (see example below).

## Required repository variables

- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `GHCR_USERNAME` — only needed when using a PAT; omit to use `github.actor`
- `CONTAINER_APP_NAME`
- `RESOURCE_GROUP_NAME`
- `TF_BACKEND_HOSTNAME`
- `TF_BACKEND_ORGANIZATION`

> `TF_BACKEND_WORKSPACE` is a caller repository variable convention. The
> reusable Terraform workflows accept this value through the `workspace_name`
> input.

## Typical repository secrets

- `TF_API_TOKEN`
- `GHCR_PAT` — required only for cross-repo or private package publishing; omit to use `GITHUB_TOKEN`

Application-specific secrets should preferably be stored in Azure Key Vault and consumed by Azure Container Apps through managed identities.

## Minimal caller workflow example

> **Tip:** Pin workflow refs to a tag or commit SHA for production use (e.g.
> `@v0.1.0`). `@main` is shown here for simplicity.

```yaml
name: deploy

on:
  push:
    branches:
      - main
  pull_request:

concurrency:
  group: production
  cancel-in-progress: false

permissions:
  contents: read
  packages: write
  pull-requests: write
  id-token: write

jobs:
  validate:
    uses: heidarj/mcp-platform/.github/workflows/terraform-validate.yml@main
    with:
      terraform_directory: ./terraform

  plan:
    if: github.event_name == 'pull_request'
    needs: validate
    uses: heidarj/mcp-platform/.github/workflows/terraform-plan.yml@main
    with:
      terraform_directory: ./terraform
      workspace_name: ${{ vars.TF_BACKEND_WORKSPACE }}
    secrets:
      TF_API_TOKEN: ${{ secrets.TF_API_TOKEN }}

  build:
    if: github.ref == 'refs/heads/main'
    uses: heidarj/mcp-platform/.github/workflows/build-container.yml@main
    with:
      image_name: kronan.mcpar.is
      dotnet_version: 9.0.x
      dockerfile_path: ./Dockerfile
      context_path: .
      run_tests: true
    secrets:
      GHCR_PAT: ${{ secrets.GHCR_PAT }}

  deploy:
    if: github.ref == 'refs/heads/main'
    needs: build
    uses: heidarj/mcp-platform/.github/workflows/deploy-container-app.yml@main
    with:
      container_app_name: ${{ vars.CONTAINER_APP_NAME }}
      resource_group_name: ${{ vars.RESOURCE_GROUP_NAME }}
      image: ${{ needs.build.outputs.image }}

  apply:
    if: github.ref == 'refs/heads/main'
    needs: deploy
    uses: heidarj/mcp-platform/.github/workflows/terraform-apply.yml@main
    with:
      terraform_directory: ./terraform
      workspace_name: ${{ vars.TF_BACKEND_WORKSPACE }}
    secrets:
      TF_API_TOKEN: ${{ secrets.TF_API_TOKEN }}
```

> If your repositories share an organization or enterprise,
> `secrets: inherit` can replace the explicit secret mappings above.
