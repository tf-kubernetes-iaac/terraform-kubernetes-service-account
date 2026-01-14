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