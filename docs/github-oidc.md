# GitHub OIDC for Azure

The reusable workflows in this repository assume Azure authentication is performed through GitHub OpenID Connect (OIDC). The workflows execute in the caller repository context, so each consuming repository must own its own Azure federated credential configuration.

## Required repository variables

The caller repository should define:

- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

## Federated credential subjects

Each MCP repository needs its own subject entries in Azure, for example:

- `repo:heidarj/outlook.mcpar.is:ref:refs/heads/main`
- `repo:heidarj/kronan.mcpar.is:ref:refs/heads/main`

If pull request or environment-specific branches are introduced later, add the corresponding subject patterns in Azure.

## Why no Azure secrets are stored here

This platform repository does not own Azure credentials. Reusable workflows authenticate with `azure/login` and GitHub OIDC so that every consuming repository can remain independently deployable without sharing long-lived secrets with the platform repository.
