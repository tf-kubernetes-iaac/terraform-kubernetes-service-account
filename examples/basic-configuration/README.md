# Basic Service Account Configuration

This example demonstrates how to create a simple Kubernetes Service Account with minimal configuration.

## Overview

This is the most straightforward use case for the module, creating a service account with just:
- A name
- A namespace

## Usage

```hcl
module "basic_service_account" {
  source  = "tf-kubernetes-iaac/service-account/kubernetes"
  version = "1.0.0"

  name      = "basic-app-sa"
  namespace = "default"
}
```

## Running the Example

```bash
terraform init
terraform plan
terraform apply
```

## What Gets Created

- A Kubernetes Service Account named `basic-app-sa` in the `default` namespace
- No labels, annotations, or secrets by default

## Outputs

After applying this example, you'll get:

- `service_account_name` - The name of the service account
- `service_account_namespace` - The namespace where it was created
- `service_account_uid` - The unique identifier of the service account

## Next Steps

- Check the `with-labels-and-annotations` example to add metadata
- See `with-image-pull-secrets` to configure registry access
- Review `with-token-generation` for token management in Kubernetes >=1.24
