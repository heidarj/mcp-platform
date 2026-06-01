# Azure Container Apps deployment

`build-container.yml` and `deploy-container-app.yml` are designed to let each MCP service repository keep its own application code and Dockerfile while delegating build and deployment orchestration to `mcp-platform`.

## Build workflow responsibilities

`.github/workflows/build-container.yml`:

- optionally runs `.NET` tests
- authenticates to GitHub Container Registry (GHCR)
- builds the Docker image from the caller repository
- pushes the image to GHCR
- returns the final image reference and image tag

## Deploy workflow responsibilities

`.github/workflows/deploy-container-app.yml`:

- authenticates to Azure with OIDC
- updates the Azure Container App image
- triggers a new revision by changing the image reference

## Caller repository requirements

Typical caller-side variables and secrets are:

- Variable: `GHCR_USERNAME`
- Variable: `CONTAINER_APP_NAME`
- Variable: `RESOURCE_GROUP_NAME`
- Secret: `GHCR_PAT`

Call the reusable workflows with `secrets: inherit` so the workflows execute with the caller repository's package and infrastructure credentials.
