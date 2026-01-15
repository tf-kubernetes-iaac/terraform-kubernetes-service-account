variable "name" {
  type = string
  description = "Enter the name of service account that you want to create."
}

variable "namespace" {
    type = string
    description = "Enter the namespace for which you want to create Service account for."
}

variable "automount_service_account_token" {
    type = bool
    description = "Set Auto Mounting for token inside Pods"
    default = false
}

variable "labels" {
    type = map(string)
    description = "Labels for Service Account"
    default = {}
}
variable "annotations" {
  type        = map(string)
  description = "Annotations for the service account."
  default     = {}
}

variable "image_pull_secrets" {
    description = "List of secrets that is used for pulling image"
    type = list(string)
    default = []
}

variable "mountable_secrets" {
    description = "List of Mountable secrets to be used by pods"
    type = list(string)
    default = []
}

variable "create_token" {
    description = "Create a service-account-token secret (required for K8s >=1.24)"
    type = bool
    default = false
  
}