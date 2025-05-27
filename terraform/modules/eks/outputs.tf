output "eks_cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.this.certificate_authority
}

output "cluster_sg_group_id" {
  value = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "eks_cluster_token" {
  value = aws_eks_cluster.this.token
}