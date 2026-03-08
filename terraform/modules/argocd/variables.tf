variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "application" {
  description = "Application or project name"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "argocd_namespace" {
  description = "Kubernetes namespace for ArgoCD"
  type        = string
  default     = "argocd"
}