resource "helm_release" "cluster-autoscaler" {
  chart      = "cluster-autoscaler"
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  version    = "9.35.0"

  set {
    name  = "resources.limits.cpu"
    value = "1000m"
  }
  set {
    name  = "resources.limits.memory"
    value = "1000Mi"
  }
  set {
    name  = "resources.requests.cpu"
    value = "500m"
  }
  set {
    name  = "resources.requests.memory"
    value = "500Mi"
  }
  set {
    name  = "autoDiscovery.clusterName"
    value = var.eks_cluster_name
  }


}

resource "helm_release" "metrics-server" {
  chart      = "metrics-server"
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  version    = "3.12.0"
}

resource "kubernetes_horizontal_pod_autoscaler" "nginx-hpa" {
  metadata {
    name = "nginx-hpa"
    namespace = "monitoring"
  }

  spec {
    max_replicas = 6
    min_replicas = 2

    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = "nginx"
    }

  target_cpu_utilization_percentage = 65 
  
}
}