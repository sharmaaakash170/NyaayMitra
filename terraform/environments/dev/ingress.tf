resource "kubernetes_ingress_v1" "frontend" {
  metadata {
    name      = "frontend-ingress"
    namespace = "default"

    annotations = {
  "kubernetes.io/ingress.class"                = "alb"
  "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
  "alb.ingress.kubernetes.io/target-type"      = "ip"
  "alb.ingress.kubernetes.io/backend-protocol" = "HTTP"
  "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
  "alb.ingress.kubernetes.io/certificate-arn"  = "arn:aws:acm:region:account:certificate/your-cert-id"
  "alb.ingress.kubernetes.io/healthcheck-path" = "/health"
  "alb.ingress.kubernetes.io/healthcheck-port" = "traffic-port"
}

  }

  spec {
    rule {
      http {
        path {
          path      = "/*"
          path_type = "Prefix"

          backend {
            service {
              name = "frontend"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [ kubernetes_service.frontend ]
}
