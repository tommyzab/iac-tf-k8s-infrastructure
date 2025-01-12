

module "network" {
  source              = "./modules/network"
  vpc_cidr            = var.vpc_cidr
  region              = var.region
  prefix              = var.prefix
  availability_zone   = var.availability_zone
  subnet_cidr_private = var.subnet_cidr_private
  subnet_cidr_public  = var.subnet_cidr_public
}


module "alb" {
  source            = "./modules/alb"
  region            = var.region
  prefix            = var.prefix
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
}


module "eks" {
  source             = "./modules/eks"
  prefix             = var.prefix
  private_subnet_ids = module.network.private_subnet_ids
  monitoring_namespace = var.monitoring_namespace
  argocd_namespace   = var.argocd_namespace
}


module "alb-controller" {
  source           = "./modules/alb-controller"
  region           = var.region
  namespace        = var.monitoring_namespace
  eks_cluster_name = module.eks.eks_cluster_name
  issuer           = module.eks.open_id_issuer
  depends_on       = [module.eks, module.alb]
}

module "monitoring" {
  source       = "./modules/monitoring"
  namespace    = var.monitoring_namespace
  alb_dns_name = module.alb.alb_dns_name
  depends_on   = [module.eks, module.alb-controller]
}


module "argocd" {
  source = "./modules/argocd"
  argocd_namespace = var.argocd_namespace
}

module "autoscaling" {
  source = "./modules/autoscaling"
  eks_cluster_name = module.eks.eks_cluster_name
}