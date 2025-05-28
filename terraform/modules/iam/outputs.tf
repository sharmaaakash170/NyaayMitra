output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_group_role_arn" {
  value = aws_iam_role.eks_node_group_role.arn
}

output "alb_ingress_role_arn" {
  description = "IAM role ARN for AWS Load Balancer Controller IRSA"
  value       = aws_iam_role.alb_ingress_role.arn
}
