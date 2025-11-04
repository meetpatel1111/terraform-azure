# Terraform Azure Infra – Modular Starter (with Naming Conventions)

This project deploys Azure networking, compute, storage, and IAM using **Terraform modules** and **environment tfvars**.  
It follows a standardized naming convention using locals:

```
<service>-<classification>-<region>-<environment>
e.g., vm-np-uks-dev
```

- `service` — Azure resource type (vm, vnet, snet, nsg, nic, pip, st)
- `classification` — `p` for prod, `np` for non-prod
- `region` — short code (e.g., `uks` for `uksouth`)
- `environment` — `dev`, `test`, or `prod`

## Quick Start
```bash
terraform init
terraform plan -var-file=environments/dev.tfvars
terraform apply -var-file=environments/dev.tfvars
```

## Remote State
Update `backend.tf` for Azure Storage backend and run `terraform init -migrate-state`.

## CI/CD
GitHub Actions workflow in `.github/workflows/terraform-ci-cd.yml` supports PR plans, manual apply, and OIDC auth.
