# mcp-platform

`mcp-platform` is the shared deployment platform for independent MCP services such as `outlook.mcpar.is`, `kronan.mcpar.is`, and future `*.mcpar.is` repositories.

This repository intentionally keeps application code out of the platform layer. It centralizes reusable GitHub Actions workflows, deployment conventions, onboarding guidance, and room for future shared Terraform modules.

## What lives here

- Reusable GitHub Actions workflows for building containers, deploying Azure Container Apps, and running Terraform
- Shared deployment and authentication conventions
- Onboarding documentation for new MCP services
- A placeholder location for future shared Terraform modules

## What does **not** live here

- MCP server implementations
- `.NET` application projects
- Application Dockerfiles
- Application-specific Terraform
- Application-specific secrets

## Calling the reusable workflows

A consuming repository can keep its own application code, Dockerfile, and Terraform while delegating deployment logic to this repository.

> **Production callers** should pin to a tag or commit SHA instead of `@main`
> to avoid unexpected changes. For example:
> `heidarj/mcp-platform/.github/workflows/build-container.yml@v0.1.0`

```yaml
name: deploy

on:
  push:
    branches:
      - main

concurrency:
  group: production
  cancel-in-progress: false

permissions:
  contents: read
  packages: write
  id-token: write

jobs:
  build:
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
    needs: build
    uses: heidarj/mcp-platform/.github/workflows/deploy-container-app.yml@main
    with:
      container_app_name: ${{ vars.CONTAINER_APP_NAME }}
      resource_group_name: ${{ vars.RESOURCE_GROUP_NAME }}
      image: ${{ needs.build.outputs.image }}
```

> **Note:** If your repositories are in the same GitHub organization or
> enterprise, you can use `secrets: inherit` as a shortcut instead of mapping
> each secret explicitly.

Additional workflow guidance is available in:

- `docs/onboarding.md`
- `docs/github-oidc.md`
- `docs/container-apps.md`
- `docs/terraform-backend.md`

## Licensing

This repository is licensed under the GNU General Public License v3.0 or later. See `LICENSE` for the full text.

If you need to use this platform under terms other than GPL v3, commercial licenses can be purchased separately.
