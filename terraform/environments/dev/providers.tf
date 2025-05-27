provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host = module.eks.cluster_endpoint
  cluster_ca_certificate = base64encode(module.eks.cluster_ca_certificate[0].data)
  token = module.eks.eks_cluster_token
}