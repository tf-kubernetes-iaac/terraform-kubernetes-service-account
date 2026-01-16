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

# Example: Service Account with Image Pull Secrets
# This example shows how to configure a service account to access
# private container registries (Docker Hub, ECR, GCR, etc.)
module "service_account_with_pull_secrets" {
  source  = "tf-kubernetes-iaac/service-account/kubernetes"
  version = "2.0.0"

  name      = "app-with-registry-access"
  namespace = "applications"

  labels = {
    app        = "my-app"
    team       = "backend"
    environment = "production"
  }

  annotations = {
    "description" = "Service account with private registry access"
    "owner"       = "backend-team@example.com"
  }

  # Configure image pull secrets for private registries
  image_pull_secrets = [
    "docker-registry-prod",      # Docker Hub private registry
    "ecr-prod-credential",       # AWS ECR
    "gcr-prod-credential",       # Google Container Registry
  ]
}

output "service_account_name" {
  description = "The name of the created service account"
  value       = module.service_account_with_pull_secrets.name
}

output "service_account_namespace" {
  description = "The namespace of the created service account"
  value       = module.service_account_with_pull_secrets.namespace
}

output "image_pull_secrets" {
  description = "Image pull secrets configured for this service account"
  value       = [
    "docker-registry-prod",
    "ecr-prod-credential",
    "gcr-prod-credential",
  ]
}
