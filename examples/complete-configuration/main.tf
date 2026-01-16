terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 3.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Example: Complete Service Account Configuration
# This example demonstrates a production-ready service account with all features:
# - Comprehensive labels and annotations
# - Token generation for Kubernetes 1.24+
# - Image pull secrets for private registries
# - Mountable secrets for application configuration
# - Token auto-mounting enabled for pod access

module "complete_service_account" {
  source  = "tf-kubernetes-iaac/service-account/kubernetes"
  version = "2.0.0"

  name      = "production-app-sa"
  namespace = "production"

  # Comprehensive labeling for organization and tracking
  labels = {
    app            = "production-application"
    team           = "platform"
    environment    = "production"
    managed-by     = "terraform"
    cost-center    = "engineering"
    compliance     = "pci-dss"
    backup-policy  = "daily"
  }

  # Detailed annotations for operational metadata
  annotations = {
    "description"              = "Production service account for main application deployment"
    "owner"                    = "platform-team@example.com"
    "slack-channel"            = "#prod-alerts"
    "documentation"            = "https://wiki.example.com/runbooks/prod-app"
    "runbook"                  = "https://wiki.example.com/runbooks/prod-app-troubleshoot"
    "backup.velero.io/backup"  = "true"
    "prometheus.io/scrape"     = "true"
    "policy.kyverno.io/enforce" = "true"
    "cost-center"              = "engineering"
    "compliance-level"         = "pci-dss"
    "created-by"               = "platform-team"
  }

  # Token generation for Kubernetes 1.24+
  create_token = true

  # Auto-mount token in pods for in-pod API access
  automount_service_account_token = true

  # Image pull secrets for private registries
  image_pull_secrets = [
    "docker-registry-prod",
    "ecr-prod-credential",
    "gcr-prod-credential",
  ]

  # Mountable secrets for application use
  mountable_secrets = [
    "database-credentials",
    "api-keys",
    "tls-certificates",
    "encryption-keys",
  ]
}

# Service account for batch jobs
module "batch_job_service_account" {
  source  = "tf-kubernetes-iaac/service-account/kubernetes"
  version = "2.0.0"

  name      = "batch-jobs-sa"
  namespace = "production"

  labels = {
    app        = "batch-processor"
    team       = "data"
    purpose    = "batch-jobs"
    environment = "production"
  }

  annotations = {
    "description"  = "Service account for batch job execution"
    "owner"        = "data-team@example.com"
    "schedule"     = "Daily at 2 AM UTC"
    "documentation" = "https://wiki.example.com/batch-jobs"
  }

  create_token = true
  automount_service_account_token = true

  image_pull_secrets = [
    "ecr-prod-credential",
  ]

  mountable_secrets = [
    "batch-config",
    "database-credentials",
  ]
}

# Service account for monitoring and observability
module "monitoring_service_account" {
  source  = "tf-kubernetes-iaac/service-account/kubernetes"
  version = "2.0.0"

  name      = "monitoring-sa"
  namespace = "monitoring"

  labels = {
    app        = "prometheus-stack"
    team       = "platform"
    purpose    = "monitoring"
    environment = "production"
  }

  annotations = {
    "description"  = "Service account for Prometheus and monitoring stack"
    "owner"        = "platform-team@example.com"
    "documentation" = "https://wiki.example.com/monitoring"
  }

  create_token = true
  automount_service_account_token = true

  image_pull_secrets = [
    "docker-registry-prod",
  ]

  mountable_secrets = [
    "prometheus-config",
    "alertmanager-config",
  ]
}

# Outputs
output "production_app_sa" {
  description = "Production application service account details"
  value = {
    name      = module.complete_service_account.name
    namespace = module.complete_service_account.namespace
    uid       = module.complete_service_account.uid
    token     = module.complete_service_account.token_secret_name
  }
}

output "batch_job_sa" {
  description = "Batch job service account details"
  value = {
    name      = module.batch_job_service_account.name
    namespace = module.batch_job_service_account.namespace
    uid       = module.batch_job_service_account.uid
    token     = module.batch_job_service_account.token_secret_name
  }
}

output "monitoring_sa" {
  description = "Monitoring service account details"
  value = {
    name      = module.monitoring_service_account.name
    namespace = module.monitoring_service_account.namespace
    uid       = module.monitoring_service_account.uid
    token     = module.monitoring_service_account.token_secret_name
  }
}
