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

```yaml
name: deploy

on:
  push:
    branches:
      - main

jobs:
  build:
    uses: heidarj/mcp-platform/.github/workflows/build-container.yml@main
    with:
      image_name: kronan.mcpar.is
      dotnet_version: 9.0.x
      dockerfile_path: ./Dockerfile
      context_path: .
      run_tests: true
    secrets: inherit

  deploy:
    needs: build
    uses: heidarj/mcp-platform/.github/workflows/deploy-container-app.yml@main
    with:
      container_app_name: ${{ vars.CONTAINER_APP_NAME }}
      resource_group_name: ${{ vars.RESOURCE_GROUP_NAME }}
      image: ${{ needs.build.outputs.image }}
    secrets: inherit
```

Additional workflow guidance is available in:

- `docs/onboarding.md`
- `docs/github-oidc.md`
- `docs/container-apps.md`
- `docs/terraform-backend.md`

## Licensing

This repository is licensed under the GNU General Public License v3.0 or later. See `LICENSE` for the full text.

If you need to use this platform under terms other than GPL v3, commercial licenses can be purchased separately.
