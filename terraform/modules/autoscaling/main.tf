resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = "9.29.0"

  set {
    name  = "autoDiscovery.clusterName"
    value = var.eks_cluster_name
  }

  set {
    name  = "awsRegion"
    value = data.aws_region.current.name
  }

  # Resource optimization
  set {
    name  = "resources.requests.cpu"
    value = "100m"
  }
  set {
    name  = "resources.requests.memory"
    value = "128Mi"
  }
  set {
    name  = "resources.limits.cpu"
    value = "200m"
  }
  set {
    name  = "resources.limits.memory"
    value = "256Mi"
  }

  # Conservative scaling settings
  set {
    name  = "extraArgs.scale-down-delay-after-add"
    value = "10m"
  }
  set {
    name  = "extraArgs.scale-down-unneeded-time"
    value = "10m"
  }
}

resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = "3.11.0"

  set {
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
  }

  # Resource optimization
  set {
    name  = "resources.requests.cpu"
    value = "50m"
  }
  set {
    name  = "resources.requests.memory"
    value = "64Mi"
  }
  set {
    name  = "resources.limits.cpu"
    value = "100m"
  }
  set {
    name  = "resources.limits.memory"
    value = "128Mi"
  }
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

data "aws_region" "current" {}