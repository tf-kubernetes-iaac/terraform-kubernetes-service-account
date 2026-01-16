# Terraform Kubernetes Service Account Module

A reusable Terraform module for creating and managing **Kubernetes Service Accounts** with support for labels, annotations, image pull secrets, mountable secrets, and optional token generation.

This module is designed to be **Terraform Registry–ready**, follows best practices, and includes strong input validation to prevent misconfiguration.

---

## ✨ Features

* Create Kubernetes Service Accounts declaratively
* Support for:
  * Custom labels and annotations
  * Image pull secrets for private registries
  * Mountable secrets for pod consumption
  * Service account token generation (required for Kubernetes >=1.24)
  * Configurable token auto-mounting
* Clean and predictable outputs for downstream modules
* Compatible with CI/CD pipelines
* Works seamlessly with the `terraform-kubernetes-namespace` module

---

## 📦 Requirements

| Name                | Version  |
| ------------------- | -------- |
| Terraform           | >= 1.3   |
| Kubernetes Provider | >= 3.0.0 |

---

## ⚙️ versions.tf

This module expects the following Terraform and provider versions:

```hcl
terraform {
  required_version = ">= 1.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 3.0.0"
    }
  }
}
```

---

## 🚀 Usage

### 🔹 Basic Service Account

```hcl
module "service_account" {
  source  = "tf-kubernetes-iaac/service-account/kubernetes"
  version = "2.0.0"

  name      = "my-app"
  namespace = "default"
}
```

---

### 🔹 Service Account with Token Generation

```hcl
module "service_account" {
  source  = "tf-kubernetes-iaac/service-account/kubernetes"
  version = "2.0.0"

  name           = "my-app"
  namespace      = "default"
  create_token   = true
  automount_service_account_token = true
}
```

---

### 🔹 Service Account with Image Pull Secrets

```hcl
module "service_account" {
  source  = "tf-kubernetes-iaac/service-account/kubernetes"
  version = "2.0.0"

  name      = "my-app"
  namespace = "default"

  image_pull_secrets = [
    "docker-registry-secret",
    "ecr-credential"
  ]
}
```

---

### 🔹 Service Account with Labels and Annotations

```hcl
module "service_account" {
  source  = "tf-kubernetes-iaac/service-account/kubernetes"
  version = "2.0.0"

  name      = "my-app"
  namespace = "default"

  labels = {
    app       = "my-application"
    team      = "platform"
    env       = "production"
  }

  annotations = {
    "owner"           = "platform-team@example.com"
    "documentation"   = "https://wiki.example.com/sa"
  }
}
```

---

## 🔐 Input Variables

| Name                            | Type           | Default | Description                                                     |
| ------------------------------- | -------------- | ------- | --------------------------------------------------------------- |
| `name`                          | `string`       | n/a     | Name of the Kubernetes Service Account.                         |
| `namespace`                     | `string`       | n/a     | Namespace where the Service Account will be created.            |
| `labels`                        | `map(string)`  | `{}`    | Labels to apply to the Service Account.                         |
| `annotations`                   | `map(string)`  | `{}`    | Annotations to apply to the Service Account.                    |
| `automount_service_account_token` | `bool`        | `false` | Automatically mount the service account token in pods.          |
| `image_pull_secrets`            | `list(string)` | `[]`    | List of image pull secrets for the service account.             |
| `mountable_secrets`             | `list(string)` | `[]`    | List of secrets that can be mounted by pods.                    |
| `create_token`                  | `bool`         | `false` | Create a service-account-token secret (required for K8s >=1.24).|

---

## 📤 Outputs

| Name                | Description                       |
| ------------------- | --------------------------------- |
| `name`              | Service Account name              |
| `namespace`         | Service Account namespace         |
| `uid`               | Service Account UID               |
| `secret_names`      | Associated secret names (if any)  |
| `token_secret_name` | Manually created token secret name|

---

## 📎 Examples

See the [`examples`](./examples) directory for complete working examples:

* **[basic-configuration](./examples/basic-configuration)** – Create a simple service account
* **[with-labels-and-annotations](./examples/with-labels-and-annotations)** – Service account with comprehensive labeling
* **[with-image-pull-secrets](./examples/with-image-pull-secrets)** – Service account for private registry access
* **[with-token-generation](./examples/with-token-generation)** – Service account with token generation
* **[complete-configuration](./examples/complete-configuration)** – Full-featured production example

---

## 📝 Examples Details

Each example includes:
* A complete `main.tf` with module configuration
* A `README.md` with example-specific documentation
* Output definitions for easy verification

To use an example:

```bash
cd examples/basic-configuration
terraform init
terraform plan
terraform apply
```

---

## 🔗 Integration with Namespace Module

This module works seamlessly with the `terraform-kubernetes-namespace` module:

```hcl
module "namespace" {
  source  = "tf-kubernetes-iaac/service-account/kubernetes"
  version = "2.0.0"
  name   = "my-app"
}

module "service_account" {
  source  = "tf-kubernetes-iaac/service-account/kubernetes"
  version = "2.0.0"

  name      = "my-app-sa"
  namespace = module.namespace.namespace_name
}
```

---

## 🛠️ Best Practices

1. **Always specify labels and annotations** for better organization and observability
2. **Use image pull secrets** when deploying applications from private registries
3. **Enable token generation** for Kubernetes clusters >=1.24
4. **Mount tokens only when necessary** to reduce attack surface
5. **Use separate service accounts** for different application components

---

## 📄 License

This module is licensed under the MIT License. See [LICENSE](./LICENSE) for details.
