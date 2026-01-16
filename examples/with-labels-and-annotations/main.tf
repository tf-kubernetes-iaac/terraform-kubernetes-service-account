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

# Example: Service Account with Labels and Annotations
# This example shows how to add metadata to a service account for better
# organization, observability, and operational management.
module "service_account_with_metadata" {
  source  = "tf-kubernetes-iaac/service-account/kubernetes"
  version = "2.0.0"

  name      = "observability-sa"
  namespace = "observability"

  # Labels for organization and filtering
  labels = {
    app         = "monitoring-stack"
    team        = "platform"
    environment = "production"
    managed-by  = "terraform"
  }

  # Annotations for operational metadata
  annotations = {
    "description"              = "Service account for Prometheus and monitoring stack"
    "owner"                    = "platform-team@example.com"
    "documentation"            = "https://wiki.example.com/observability"
    "slack-channel"            = "#platform-alerts"
    "backup.velero.io/backup"  = "true"
    "cost-center"              = "infrastructure"
  }
}

output "service_account_name" {
  description = "The name of the created service account"
  value       = module.service_account_with_metadata.name
}

output "service_account_labels" {
  description = "Labels applied to the service account"
  value       = module.service_account_with_metadata.name
}

output "service_account_namespace" {
  description = "The namespace of the created service account"
  value       = module.service_account_with_metadata.namespace
}
