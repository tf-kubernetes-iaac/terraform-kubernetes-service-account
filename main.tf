resource "kubernetes_service_account_v1" "this" {
  metadata {
    name = var.name
    namespace = var.namespace
  }
}