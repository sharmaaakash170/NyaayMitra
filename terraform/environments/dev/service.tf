resource "kubernetes_service" "frontend" {
  metadata {
    name = "frontend"
  }

  spec {
    selector = {
      app = "frontend"
    }

    port {
      port        = 80
      target_port = 8081
    }

    type = "ClusterIP"
  }
}
