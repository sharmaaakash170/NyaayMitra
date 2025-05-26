output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "s3_static_site" {
  value = module.s3_cloudfront.s3_website_url
}

output "cdn_url" {
  value = module.s3_cloudfront.cloudfront_url
}

output "http_api_id" {
  value = module.api_gateway.http_api_id
}

output "aws_ecr_repository_url" {
  value = module.ecr.aws_ecr_repository_url
}