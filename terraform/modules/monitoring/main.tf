resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = var.monitoring_namespace
  version    = "25.8.0"

  set {
    name  = "server.persistentVolume.enabled"
    value = "true"
  }

  set {
    name  = "server.persistentVolume.size"
    value = "10Gi"
  }

  # Resource optimization
  set {
    name  = "server.resources.requests.cpu"
    value = "200m"
  }
  set {
    name  = "server.resources.requests.memory"
    value = "512Mi"
  }

  # Cost-effective retention settings
  set {
    name  = "prometheus.prometheusSpec.retention"
    value = "7d"
  }

  # Grafana settings
  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "grafana.persistence.enabled"
    value = "true"
  }
  set {
    name  = "grafana.persistence.size"
    value = "1Gi"
  }

  # Basic alerting rules only
  set {
    name  = "defaultRules.create"
    value = "true"
  }
  set {
    name  = "defaultRules.rules.alertmanager"
    value = "false"
  }
  set {
    name  = "alertmanager.enabled"
    value = "false"  # Disable alertmanager to save resources
  }
}

resource "kubernetes_secret" "grafana" {
  metadata {
    name      = "grafana"
    namespace = var.namespace
  }
  data = {
    admin-user     = "admin"
    admin-password = random_password.grafana.result
  }
}

resource "random_password" "grafana" {
  length = 24
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = var.monitoring_namespace
  version    = "7.0.19"

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.size"
    value = "10Gi"
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
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

  # Configure Prometheus as data source
  set {
    name  = "datasources.datasources\\.yaml.apiVersion"
    value = "1"
  }
  
  set {
    name  = "datasources.datasources\\.yaml.datasources[0].name"
    value = "Prometheus"
  }
  
  set {
    name  = "datasources.datasources\\.yaml.datasources[0].type"
    value = "prometheus"
  }
  
  set {
    name  = "datasources.datasources\\.yaml.datasources[0].url"
    value = "http://prometheus-server:80"
  }

  values = [
    templatefile("${path.module}/templates/grafana-values.yaml", {
      admin_existing_secret = kubernetes_secret.grafana.metadata[0].name
      admin_user_key       = "admin-user"
      admin_password_key   = "admin-password"
      prometheus_svc       = "${helm_release.prometheus.name}-server"
      dns_endpoint        = var.alb_dns_name
      replicas           = 1
    })
  ]
}



