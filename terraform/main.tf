module "network" {
  source              = "./modules/network"
  vpc_cidr            = var.vpc_cidr
  region              = var.region
  availability_zone   = var.availability_zone
  subnet_cidr_private = var.subnet_cidr_private
  subnet_cidr_public  = var.subnet_cidr_public
}


module "alb" {
  source            = "./modules/alb"
  region            = var.region
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
}


module "eks" {
  source              = "./modules/eks"
  private_subnet_ids  = module.network.private_subnet_ids
  monitoring_namespace = var.monitoring_namespace
  argocd_namespace    = var.argocd_namespace
  addon_name          = "vpc-cni"  # AWS VPC CNI addon
  addon_version       = "v1.12.6-eksbuild.1"  # Use appropriate version
}


module "alb-controller" {
  source           = "./modules/alb-controller"
  region           = var.region
  namespace        = var.monitoring_namespace
  eks_cluster_name = module.eks.eks_cluster_name
  cluster_name     = module.eks.eks_cluster_name
  vpc_id           = module.network.vpc_id
  issuer           = module.eks.open_id_issuer
  depends_on       = [module.eks, module.alb]
}


module "monitoring" {
  source       = "./modules/monitoring"
  namespace    = var.monitoring_namespace
  alb_dns_name = module.alb.alb_dns_name
  depends_on   = [module.eks, module.alb-controller]
}


module "autoscaling" {
  source           = "./modules/autoscaling"
  eks_cluster_name = module.eks.eks_cluster_name
}


module "argocd" {
  source           = "./modules/argocd"
  argocd_namespace = var.argocd_namespace
}

