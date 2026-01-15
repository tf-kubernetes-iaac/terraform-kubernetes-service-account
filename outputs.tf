output "name" {
  description = "Service Account name"
  value       = kubernetes_service_account_v1.this.metadata[0].name
}

output "namespace" {
  description = "Service Account namespace"
  value       = kubernetes_service_account_v1.this.metadata[0].namespace
}

output "uid" {
  description = "Service Account UID"
  value       = kubernetes_service_account_v1.this.metadata[0].uid
}

output "secret_names" {
  description = "Associated secret names (if any)"
  value       = kubernetes_service_account_v1.this.secret[*].name
}

output "token_secret_name" {
  description = "Manually created token secret name"
  value       = var.create_token ? kubernetes_secret_v1.sa_token[0].metadata[0].name : null
}
