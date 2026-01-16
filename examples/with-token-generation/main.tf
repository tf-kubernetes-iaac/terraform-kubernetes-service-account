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

# Example: Service Account with Token Generation
# This example demonstrates token generation, which is required for
# Kubernetes 1.24+ where service account tokens are no longer automatically
# created as secrets.
module "service_account_with_token" {
  source  = "tf-kubernetes-iaac/service-account/kubernetes"
  version = "2.0.0"

  name      = "app-with-token"
  namespace = "applications"

  labels = {
    app        = "backend-api"
    team       = "backend"
    environment = "production"
  }

  annotations = {
    "description" = "Service account with explicit token generation"
    "owner"       = "backend-team@example.com"
  }

  # Enable token creation (required for K8s 1.24+)
  create_token = true

  # Optionally enable token auto-mounting in pods
  # This will mount the token to /var/run/secrets/kubernetes.io/serviceaccount/token
  automount_service_account_token = true

  # Optionally specify mountable secrets
  mountable_secrets = [
    "database-credentials",
    "api-keys",
  ]
}

output "service_account_name" {
  description = "The name of the created service account"
  value       = module.service_account_with_token.name
}

output "token_secret_name" {
  description = "The name of the created service account token secret"
  value       = module.service_account_with_token.token_secret_name
}

output "service_account_namespace" {
  description = "The namespace of the created service account"
  value       = module.service_account_with_token.namespace
}

output "secret_names" {
  description = "All secrets associated with this service account"
  value       = module.service_account_with_token.secret_names
}
