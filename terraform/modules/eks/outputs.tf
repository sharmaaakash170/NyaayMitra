output "eks_cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_sg_group_id" {
  value = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.this.name
}

output "eks_cluster_token" {
  value = data.aws_eks_cluster_auth.cluster.token
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.this.arn
}

output "oidc_provider_url" {
  value = aws_iam_openid_connect_provider.this.url
}