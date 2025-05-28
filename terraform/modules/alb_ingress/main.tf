resource "kubernetes_service_account" "alb_controller_sa" {
  metadata {
    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = var.alb_controller_role_arn
    }
  }
}

resource "null_resource" "install_alb_controller" {
  provisioner "local-exec" {
    command = <<EOT
      kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
      kubectl apply -f ${path.module}/aws-lb-controller-deployment.yaml
    EOT
  }

  depends_on = [ kubernetes_service_account.alb_controller_sa ]
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = "frontend"
  }

  spec {
    selector = {
      app = "frontend"
    }

    port {
      port = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}


resource "kubernetes_ingress_v1" "frontend" {
  metadata {
    name = "frontend-ingress"
    annotations = {
      "kubernetes.io/ingress.class"                = "alb"
      "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"      = "ip"
      "alb.ingress.kubernetes.io/backend-protocol" = "HTTP"
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
              name = kubernetes_service.frontend.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_service.frontend]
}
