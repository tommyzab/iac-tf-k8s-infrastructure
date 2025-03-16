region               = "us-east-1"
vpc_cidr             = "10.0.0.0/16"
subnet_cidr_private  = ["10.0.1.0/24", "10.0.2.0/24"]
subnet_cidr_public   = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zone    = ["us-east-1a", "us-east-1b"]
monitoring_namespace = "monitoring"
argocd_namespace     = "argocd" 