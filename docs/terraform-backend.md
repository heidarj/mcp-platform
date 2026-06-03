# HCP Terraform backend

The Terraform workflows in this repository assume the caller repository stores state in HCP Terraform and passes backend configuration through repository variables.

See `docs/terraform-state.md` for the recommended workspace split between the
shared platform workspace and per-app workspaces.

## Required repository variables

- `TF_BACKEND_HOSTNAME`
- `TF_BACKEND_ORGANIZATION`

> `TF_BACKEND_WORKSPACE` is the recommended caller repository variable name.
> The reusable Terraform workflows accept it through the `workspace_name`
> input parameter. For example:
>
> ```yaml
> workspace_name: ${{ vars.TF_BACKEND_WORKSPACE }}
> ```

## Required repository secret

- `TF_API_TOKEN`

## Expected Terraform backend shape

A consuming repository can keep backend configuration partial in code and let the reusable workflows inject the organization and workspace details during `terraform init`.

```hcl
terraform {
  backend "remote" {}
}
```

## Workflow behavior

- `terraform-validate.yml` checks formatting and runs `terraform validate` without contacting the remote backend.
- `terraform-plan.yml` authenticates to Azure with OIDC, configures HCP Terraform credentials, writes a temporary backend config file with the hostname, organization, and workspace, initializes the remote backend, maps the GitHub environment name to the provided Terraform workspace name so environment-scoped variables are available, exports `TF_VAR_subscription_id` and `TF_VAR_tenant_id` from `AZURE_SUBSCRIPTION_ID` and `AZURE_TENANT_ID`, generates a plan, uploads the artifacts, and publishes the rendered plan for reviewers.
- `terraform-apply.yml` uses the same backend and authentication model, writes the same temporary backend config file shape during `terraform init`, maps the GitHub environment name to the provided Terraform workspace name so environment approval gates can be enforced, and exports the same Terraform input variables from the Azure environment variables before planning and applying.
