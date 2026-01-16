# Complete Service Account Configuration

This example demonstrates a production-ready setup with multiple service accounts showcasing all features of the module.

## Overview

This comprehensive example includes:

1. **Production Application Service Account**
   - Full feature set for main application deployment
   - Complete labeling and annotations
   - Token generation and auto-mounting
   - Multiple image pull secrets
   - Multiple mountable secrets

2. **Batch Job Service Account**
   - Dedicated account for batch processing
   - Specific configuration for job execution
   - Limited image pull secrets
   - Job-specific secret access

3. **Monitoring Service Account**
   - Dedicated account for Prometheus/monitoring
   - Monitoring-specific configuration
   - Separate namespace (monitoring)
   - Monitoring tool integration

## Usage

```hcl
module "complete_service_account" {
  source  = "tf-kubernetes-iaac/service-account/kubernetes"
  version = "2.0.0"

  name      = "production-app-sa"
  namespace = "production"

  labels = {
    app            = "production-application"
    team           = "platform"
    environment    = "production"
    # ... more labels
  }

  annotations = {
    "description"  = "Production service account for main application"
    "owner"        = "platform-team@example.com"
    # ... more annotations
  }

  create_token                    = true
  automount_service_account_token = true

  image_pull_secrets = [
    "docker-registry-prod",
    "ecr-prod-credential",
  ]

  mountable_secrets = [
    "database-credentials",
    "api-keys",
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

### Production Application SA
- Service account: `production-app-sa`
- Namespace: `production`
- Token secret: `production-app-sa-token`
- Access to 3 image pull secrets
- Access to 4 mountable secrets

### Batch Job SA
- Service account: `batch-jobs-sa`
- Namespace: `production`
- Token secret: `batch-jobs-sa-token`
- Limited image pull secrets
- Job-specific secrets

### Monitoring SA
- Service account: `monitoring-sa`
- Namespace: `monitoring`
- Token secret: `monitoring-sa-token`
- Registry access for monitoring tools
- Monitoring configuration secrets

## Key Features Demonstrated

### 1. Comprehensive Labeling

```hcl
labels = {
  app            = "production-application"    # Application identifier
  team           = "platform"                  # Responsible team
  environment    = "production"                # Deployment environment
  managed-by     = "terraform"                 # Management tool
  cost-center    = "engineering"               # Cost allocation
  compliance     = "pci-dss"                   # Compliance requirement
  backup-policy  = "daily"                     # Backup strategy
}
```

### 2. Detailed Annotations

```hcl
annotations = {
  "description"              = "..."              # Purpose
  "owner"                    = "team@example.com" # Owner contact
  "slack-channel"            = "#prod-alerts"     # Alert channel
  "documentation"            = "https://..."      # Docs link
  "runbook"                  = "https://..."      # Troubleshooting
  "backup.velero.io/backup"  = "true"            # Backup config
  "prometheus.io/scrape"     = "true"            # Monitoring
  "policy.kyverno.io/enforce" = "true"           # Policy enforcement
}
```

### 3. Token Management

```hcl
create_token                    = true    # Create token secret
automount_service_account_token = true    # Auto-mount in pods
```

### 4. Image Pull Secrets

```hcl
image_pull_secrets = [
  "docker-registry-prod",      # Docker Hub
  "ecr-prod-credential",       # AWS ECR
  "gcr-prod-credential",       # Google GCR
]
```

### 5. Mountable Secrets

```hcl
mountable_secrets = [
  "database-credentials",      # DB access
  "api-keys",                  # API authentication
  "tls-certificates",          # SSL/TLS certs
  "encryption-keys",           # Data encryption
]
```

## Architecture Pattern

This example uses the **multi-service-account pattern** for different workload types:

```
┌─────────────────────────────┐
│      Kubernetes Cluster     │
├──────────────────────────────┤
│ Production Namespace         │
│  ├─ production-app-sa        │
│  └─ batch-jobs-sa            │
│                              │
│ Monitoring Namespace         │
│  └─ monitoring-sa            │
└──────────────────────────────┘
```

## RBAC Integration

These service accounts should be paired with Role/ClusterRole definitions:

### Production App Role
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: production-app-role
  namespace: production
rules:
- apiGroups: [""]
  resources: ["configmaps", "secrets"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
```

### Batch Job Role
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: batch-job-role
  namespace: production
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get"]
- apiGroups: ["batch"]
  resources: ["jobs"]
  verbs: ["get", "list", "watch"]
```

## Deployment Usage

### Using Production App SA

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: production-app
  namespace: production
spec:
  template:
    spec:
      serviceAccountName: production-app-sa
      containers:
      - name: app
        image: myapp:latest
        volumeMounts:
        - name: db-creds
          mountPath: /etc/secrets/db
      volumes:
      - name: db-creds
        secret:
          secretName: database-credentials
```

### Using Batch Job SA

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: batch-processor
  namespace: production
spec:
  schedule: "0 2 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          serviceAccountName: batch-jobs-sa
          containers:
          - name: processor
            image: batch-processor:latest
```

### Using Monitoring SA

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: monitoring
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
  namespace: monitoring
spec:
  template:
    spec:
      serviceAccountName: monitoring-sa
      containers:
      - name: prometheus
        image: prom/prometheus:latest
```

## Outputs

After applying, retrieve service account information:

```bash
# Get all service account details
terraform output production_app_sa
terraform output batch_job_sa
terraform output monitoring_sa

# Or get specific information
terraform output -json | jq '.production_app_sa.value'
```

## Security Best Practices

1. **Principle of Least Privilege**: Each SA has minimal required permissions
2. **Separate Namespaces**: Isolate different workload types
3. **RBAC Integration**: Pair with appropriate Role/ClusterRole
4. **Secret Management**: Use external secret management (Sealed Secrets, Vault)
5. **Audit Logging**: Track all service account usage
6. **Regular Rotation**: Rotate tokens periodically
7. **Monitoring**: Monitor token usage and access patterns

## Verification

```bash
# List all created service accounts
kubectl get serviceaccount -n production
kubectl get serviceaccount -n monitoring

# Verify token secrets
kubectl get secrets -n production | grep token
kubectl get secrets -n monitoring | grep token

# Check service account details
kubectl describe sa production-app-sa -n production
kubectl describe sa monitoring-sa -n monitoring
```

## Next Steps

- Integrate with RBAC (Role/ClusterRole/RoleBinding)
- Set up secret management (Sealed Secrets, Vault)
- Configure network policies
- Implement audit logging
- Set up monitoring and alerting

## Additional Resources

- [Kubernetes Service Accounts](https://kubernetes.io/docs/concepts/security/service-accounts/)
- [RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [Security Best Practices](https://kubernetes.io/docs/concepts/security/)
