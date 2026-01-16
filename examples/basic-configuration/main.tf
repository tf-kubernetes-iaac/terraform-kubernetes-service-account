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

# Example: Basic Service Account
# This example demonstrates the simplest way to create a service account
# with minimal configuration.
module "basic_service_account" {
  source  = "tf-kubernetes-iaac/service-account/kubernetes"
  version = "2.0.0"

  name      = "basic-app-sa"
  namespace = "default"
}

output "service_account_name" {
  description = "The name of the created service account"
  value       = module.basic_service_account.name
}

output "service_account_namespace" {
  description = "The namespace of the created service account"
  value       = module.basic_service_account.namespace
}

output "service_account_uid" {
  description = "The UID of the created service account"
  value       = module.basic_service_account.uid
}
