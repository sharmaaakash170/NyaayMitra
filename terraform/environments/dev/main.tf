module "vpc" {
  source = "../../modules/vpc"
  env = var.env
  tags = var.tags
  azs = var.azs 
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  vpc_cidr = var.vpc_cidr
}

module "iam" {
  source = "../../modules/iam"
  env = var.env
  tags = var.tags
}

module "ecr" {
  source = "../../modules/ecr"
  env = var.env
  tags = var.tags
}

module "eks" {
  source = "../../modules/eks"
  env = var.env 
  tags = var.tags
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_group_role_arn = module.iam.eks_node_group_role_arn
  instance_types = var.instance_types
  private_subnet_ids = module.vpc.private_subnets
  
  depends_on = [ module.vpc, module.iam ]
}

module "rds" {
  source = "../../modules/rds"
  env = var.env
  tags = var.tags
  db_security_group_id = module.vpc.db_security_group_id
  private_subnet_ids = module.vpc.private_subnets
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

module "s3_cloudfront" {
  source = "../../modules/s3-cloudfront"
  env = var.env
  tags = var.tags
}

module "api_gateway" {
  source = "../../modules/apigateway"
  env = var.env 
  tags = var.tags
}