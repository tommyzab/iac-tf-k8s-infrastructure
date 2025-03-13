variable "private_subnet_ids" {
  description = "IDs of the private subnets"
  type        = list(any)
}

variable "monitoring_namespace" {
  description = "Kubernetes namespace for monitoring"
  type        = string
  default     = "monitoring"
}

variable "argocd_namespace" {
  description = "Kubernetes namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "addon_name" {
  description = "Name of the EKS addon"
  type        = string
}

variable "addon_version" {
  description = "Version of the EKS addon"
  type        = string
}