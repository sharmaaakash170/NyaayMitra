provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token = module.eks.eks_cluster_token
}