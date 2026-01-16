# Service Account with Labels and Annotations

This example demonstrates how to create a Kubernetes Service Account with comprehensive labeling and annotations for better organization and operational management.

## Overview

Labels and annotations are crucial for:
- **Organization**: Group related resources
- **Observability**: Track ownership and responsibility
- **Automation**: Enable label-based selection and filtering
- **Documentation**: Store important metadata and references

## Usage

```hcl
module "service_account_with_metadata" {
  source  = "tf-kubernetes-iaac/service-account/kubernetes"
  version = "2.0.0"

  name      = "observability-sa"
  namespace = "observability"

  labels = {
    app         = "monitoring-stack"
    team        = "platform"
    environment = "production"
    managed-by  = "terraform"
  }

  annotations = {
    "description"              = "Service account for Prometheus and monitoring stack"
    "owner"                    = "platform-team@example.com"
    "documentation"            = "https://wiki.example.com/observability"
    "slack-channel"            = "#platform-alerts"
    "backup.velero.io/backup"  = "true"
    "cost-center"              = "infrastructure"
  }
}
```

## Running the Example

```bash
terraform init
terraform plan
terraform apply
```

## What Gets Created

- A Kubernetes Service Account with:
  - **Labels** for organizational categorization
  - **Annotations** for operational metadata and documentation
  - Proper ownership and cost tracking information

## Key Features

### Labels
- `app`: Identifies the application or component
- `team`: Indicates the responsible team
- `environment`: Specifies the deployment environment
- `managed-by`: Shows resource management tool

### Annotations
- `description`: Human-readable purpose
- `owner`: Team or person responsible
- `documentation`: Link to relevant documentation
- `slack-channel`: Alert notification channel
- `backup.velero.io/backup`: Backup policy integration
- `cost-center`: For cost tracking and allocation

## Best Practices

1. **Consistent Label Names**: Use kebab-case for label names
2. **Meaningful Values**: Labels should contain specific, useful information
3. **Annotation URLs**: Keep documentation links up-to-date
4. **Owner Information**: Always document who is responsible
5. **Cost Tracking**: Include cost-center for billing purposes

## Querying by Labels

Once created, you can query resources by labels:

```bash
# List all service accounts with team=platform label
kubectl get serviceaccount -l team=platform

# List all resources for the observability namespace
kubectl get all -n observability -l app=monitoring-stack
```

## Next Steps

- Check the `with-image-pull-secrets` example for registry access
- See `with-token-generation` for token management
- Review `complete-configuration` for a full-featured setup
