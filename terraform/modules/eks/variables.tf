variable "prefix" {}
variable "private_subnet_ids" {
  description = "IDs of the private subnets"
  type        = list(any)
}



variable "addon_name" {
  default = "aws-ebs-csi-driver"
}

variable "addon_version" {
  default = "v1.28.0-eksbuild.1"
}

variable "monitoring_namespace" {
  
}

variable "argocd_namespace" {
  default = "argocd"
}