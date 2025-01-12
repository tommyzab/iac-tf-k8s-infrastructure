resource "helm_release" "argo_cd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.6.0"
  namespace  = var.argocd_namespace
  create_namespace = true

  values = [
    file("./modules/argocd/application.yaml")
  ]
}