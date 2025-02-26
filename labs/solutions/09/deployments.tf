resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-deployment"
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"

    #      resources {
    #        requests = {
    #          cpu = "100m"
    #        }
    #        limits = {
    #          cpu = "200m"
    #        }
    #      }

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-service"
  }
  spec {
    selector = {
      app = "nginx"
    }
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "nginx_hpa" {
  metadata {
    name = "nginx-hpa"
  }

  spec {
    max_replicas = 4
    min_replicas = 2
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.nginx.metadata[0].name
    }
    target_cpu_utilization_percentage = 5
  }
}
