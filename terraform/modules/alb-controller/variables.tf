variable "region" {
  description = "Name region"
  type        = string
}

variable "namespace" {
  description = "Namespace"
  type        = string
}


variable "eks_cluster_name" {
  description = "Name of EKS Cluster"
}


variable "issuer" {
  description = "Issuer OIDC"
}

