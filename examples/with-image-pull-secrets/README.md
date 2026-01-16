# Service Account with Image Pull Secrets

This example demonstrates how to configure a Kubernetes Service Account to access private container registries.

## Overview

Image pull secrets are essential for:
- **Private Registries**: Access Docker Hub private repositories
- **Cloud Registries**: Use AWS ECR, Google GCR, Azure ACR
- **Enterprise Registries**: Connect to private registry infrastructure
- **Security**: Authenticate and authorize image pulls

## Prerequisites

Before running this example, you need to create the image pull secrets in your Kubernetes cluster:

```bash
# Create a Docker registry secret
kubectl create secret docker-registry docker-registry-prod \
  --docker-server=docker.io \
  --docker-username=<USERNAME> \
  --docker-password=<PASSWORD> \
  --docker-email=<EMAIL> \
  -n applications

# Create an ECR secret
kubectl create secret docker-registry ecr-prod-credential \
  --docker-server=<ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com \
  --docker-username=AWS \
  --docker-password=<ECR_TOKEN> \
  -n applications

# Create a GCR secret
kubectl create secret docker-registry gcr-prod-credential \
  --docker-server=gcr.io \
  --docker-username=_json_key \
  --docker-password="$(cat /path/to/gcr-key.json)" \
  -n applications
```

## Usage

```hcl
module "service_account_with_pull_secrets" {
  source  = "tf-kubernetes-iaac/service-account/kubernetes"
  version = "2.0.0"

  name      = "app-with-registry-access"
  namespace = "applications"

  image_pull_secrets = [
    "docker-registry-prod",
    "ecr-prod-credential",
    "gcr-prod-credential",
  ]
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
  - Configuration to use the specified image pull secrets
  - Ability to pull images from multiple private registries
  - Automatic secret attachment for pod deployments

## How It Works

When a pod uses this service account, Kubernetes will:
1. Automatically use the associated image pull secrets
2. Authenticate to the specified registries
3. Pull private container images

## Using the Service Account

Once created, reference it in your pod specification:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-app-pod
  namespace: applications
spec:
  serviceAccountName: app-with-registry-access
  containers:
  - name: app
    image: docker.io/mycompany/my-private-app:latest
    # Image will be pulled using the configured secrets
```

Or with Deployment:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  namespace: applications
spec:
  template:
    spec:
      serviceAccountName: app-with-registry-access
      containers:
      - name: app
        image: docker.io/mycompany/my-private-app:latest
```

## Supported Registries

This example includes secrets for:

| Registry | Description | Usage |
|----------|-------------|-------|
| Docker Hub | Private Docker repositories | `docker.io/mycompany/image` |
| AWS ECR | Amazon Elastic Container Registry | `ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/image` |
| Google GCR | Google Container Registry | `gcr.io/project-id/image` |

You can add more registries by:
1. Creating additional secrets in Kubernetes
2. Adding them to the `image_pull_secrets` list

## Best Practices

1. **Separate Secrets by Registry**: Use different secrets for each registry
2. **Use Short-lived Credentials**: Rotate tokens regularly
3. **Restrict Secret Access**: Limit who can read these secrets
4. **Use Namespaces**: Keep secrets in the same namespace as the service account
5. **Document Ownership**: Annotate who manages each registry credential

## Troubleshooting

Check if secrets exist:
```bash
kubectl get secrets -n applications
```

Verify the service account has the secrets:
```bash
kubectl get serviceaccount app-with-registry-access -n applications -o yaml
```

Check image pull events:
```bash
kubectl describe pod <pod-name> -n applications
```

## Next Steps

- See `with-token-generation` for token management
- Check `complete-configuration` for a full-featured setup
- Review `with-labels-and-annotations` for better metadata
