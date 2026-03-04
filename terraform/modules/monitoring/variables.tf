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

variable "alb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
}

variable "monitoring_namespace" {
  description = "Kubernetes namespace for monitoring tools"
  type        = string
  default     = "monitoring"
}