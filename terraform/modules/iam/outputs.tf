output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_group_role_arn" {
  value = aws_iam_role.eks_node_group_role.arn
}

output "service_account_role_arn" {
  value = aws_iam_role.ebs_csi_driver_irsa_role.arn
}