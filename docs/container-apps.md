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

- Variable: `GHCR_USERNAME` — only needed when using a PAT; omit to use `github.actor`
- Variable: `CONTAINER_APP_NAME`
- Variable: `RESOURCE_GROUP_NAME`
- Secret: `GHCR_PAT` — required only for cross-repo or private package publishing; omit to use `GITHUB_TOKEN`

The build workflow defaults to `GITHUB_TOKEN` for same-repository GHCR
publishing. Supply `GHCR_PAT` only when the image is pushed to a registry
owned by a different user/org or when the package visibility is private and
`GITHUB_TOKEN` does not have enough access.

### Caller permissions

Because reusable workflows cannot elevate beyond what the caller grants, the
caller workflow must include at least:

```yaml
permissions:
  contents: read
  packages: write   # for GHCR publishing
  id-token: write   # for Azure OIDC
```

### Explicit secret mapping

```yaml
secrets:
  GHCR_PAT: ${{ secrets.GHCR_PAT }}
```

If your repositories share an organization or enterprise,
`secrets: inherit` can replace the explicit mapping above.
