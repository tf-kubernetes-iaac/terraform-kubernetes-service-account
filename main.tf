resource "kubernetes_service_account_v1" "this" {
  metadata {
    name = var.name
    namespace = var.namespace
    labels = var.labels
    annotations = var.annotations
  }
  automount_service_account_token = var.automount_service_account_token
  dynamic "image_pull_secret" {
    for_each = var.image_pull_secrets
    content {
      name = image_pull_secret.value
    }
  }

  dynamic "secret" {
    for_each = var.mountable_secrets

    content {
      name = secret.value
    }
  }
}

resource "kubernetes_secret_v1" "sa_token" {
    count = var.create_token ? 1 : 0

    metadata {
      name = "${var.name}-token"
      namespace = var.namespace

      annotations = {
        "kubernetes.io/service-account.name" = kubernetes_service_account_v1.this.metadata[0].name
      }
    }

    type = "kubernetes.io/service-account-token"
  
}