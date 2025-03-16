region               = "us-east-1"
vpc_cidr             = "10.1.0.0/16"
subnet_cidr_private  = ["10.1.1.0/24", "10.1.2.0/24"]
subnet_cidr_public   = ["10.1.3.0/24", "10.1.4.0/24"]
availability_zone    = ["us-east-1a", "us-east-1b"]
monitoring_namespace = "monitoring"
argocd_namespace     = "argocd" 