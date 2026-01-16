# Service Account with Token Generation

This example demonstrates how to create a Kubernetes Service Account with explicit token generation, which is essential for Kubernetes 1.24 and later.

## Overview

Token generation is crucial because:
- **Kubernetes 1.24+**: Service account tokens are no longer auto-created as secrets
- **Explicit Management**: Direct control over token lifecycle
- **Security**: Better control over token distribution
- **Pod Authentication**: Enables in-pod API access

## Changes in Kubernetes 1.24

In Kubernetes 1.24+:
- Service account tokens are **no longer automatically created** as secret objects
- Use `create_token = true` to explicitly create token secrets
- Tokens are stored in secrets with the `kubernetes.io/service-account-token` type

## Usage

```hcl
module "service_account_with_token" {
  source  = "tf-kubernetes-iaac/service-account/kubernetes"
  version = "2.0.0"

  name               = "app-with-token"
  namespace          = "applications"
  create_token       = true  # Explicitly create the token secret
  automount_service_account_token = true  # Auto-mount in pods
}
```

## Running the Example

```bash
terraform init
terraform plan
terraform apply
```

## What Gets Created

- A Kubernetes Service Account named `app-with-token`
- A service account token secret named `app-with-token-token`
- Token automatically mounted to `/var/run/secrets/kubernetes.io/serviceaccount/` in pods

## Token Access in Pods

When `automount_service_account_token = true`, the token is available at:

```
/var/run/secrets/kubernetes.io/serviceaccount/token
/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
/var/run/secrets/kubernetes.io/serviceaccount/namespace
```

### Example: Using the Token

```bash
# Inside a pod
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
CA_CERT=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

# Query Kubernetes API
curl -H "Authorization: Bearer $TOKEN" \
     --cacert $CA_CERT \
     https://kubernetes.default.svc.cluster.local/api/v1/namespaces/$NAMESPACE/pods
```

## Configuration Options

### Token Generation

```hcl
# Enable token creation
create_token = true
```

### Auto-mounting

```hcl
# Automatically mount token in pods (default behavior)
automount_service_account_token = true

# Disable auto-mounting (pods must manually specify the token mount)
automount_service_account_token = false
```

### Mountable Secrets

```hcl
# Specify which secrets can be mounted by pods
mountable_secrets = [
  "database-credentials",
  "api-keys",
]
```

## Security Considerations

1. **Disable Auto-mount by Default**: Only enable when needed
   ```hcl
   automount_service_account_token = false
   ```

2. **Use Pod-level Overrides**: Override at pod level if needed
   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: my-pod
   spec:
     serviceAccountName: app-with-token
     automountServiceAccountToken: false  # Override
   ```

3. **Restrict Permissions**: Use RBAC to limit what the service account can do
   ```yaml
   apiVersion: rbac.authorization.k8s.io/v1
   kind: Role
   metadata:
     name: limited-role
   rules:
   - apiGroups: [""]
     resources: ["pods", "pods/log"]
     verbs: ["get", "list"]
   ```

4. **Monitor Token Usage**: Track who uses which tokens
5. **Rotate Tokens**: Periodically rotate service account tokens

## Retrieving the Token

Get the token secret name:
```bash
terraform output token_secret_name
```

Retrieve the token:
```bash
kubectl get secret <token-secret-name> -n applications \
  -o jsonpath='{.data.token}' | base64 -d
```

## Checking Token Status

```bash
# List all secrets for the service account
kubectl get secrets -n applications | grep app-with-token

# Describe the token secret
kubectl describe secret app-with-token-token -n applications

# Get the token value (decoded)
kubectl get secret app-with-token-token -n applications \
  -o jsonpath='{.data.token}' | base64 -d | cut -d. -f2 | base64 -d | jq .
```

## Kubernetes Version Compatibility

| Version | Token Secret | Required Action |
|---------|--------------|-----------------|
| < 1.24  | Auto-created | None needed |
| 1.24+   | Not created  | Set `create_token = true` |

## Next Steps

- See `with-image-pull-secrets` for registry access
- Check `complete-configuration` for a full-featured setup
- Review `with-labels-and-annotations` for better metadata

## Additional Resources

- [Kubernetes Service Accounts Documentation](https://kubernetes.io/docs/concepts/security/service-accounts/)
- [Kubernetes 1.24 Release Notes](https://kubernetes.io/blog/2022/05/kubernetes-1-24-release/)
