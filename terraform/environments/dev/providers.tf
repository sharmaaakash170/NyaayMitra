provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}

provider "kubernetes" {
  host = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)

  token = data.aws_eks_cluster_auth.this.token

}