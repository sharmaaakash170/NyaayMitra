output "alb_ingress_role_arn" {
  description = "IAM role ARN for AWS Load Balancer Controller IRSA"
  value       = aws_iam_role.alb_ingress_role.arn
}
