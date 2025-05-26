resource "aws_eks_cluster" "this" {
  name = "${var.env}-eks-cluster"
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }

  tags = merge(var.tags, {
    Environment = var.env
  })
}

resource "aws_eks_node_group" "this" {
  cluster_name = aws_eks_cluster.this.name
  node_group_name = "${var.env}-node-group"
  node_role_arn = var.eks_node_group_role_arn
  subnet_ids = var.private_subnet_ids

  scaling_config {
    desired_size = 2
    max_size = 3
    min_size = 1
  }

  tags = merge(var.tags, {
    Environment = var.env
  })

  disk_size = 20

  instance_types = var.instance_types
}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = aws_eks_cluster.this.name
  addon_name = "aws-ebs-csi-driver"
  addon_version = "v1.44.0-eksbuild.1"
  resolve_conflicts = "OVERWRITE"
  service_account_role_arn = var.eks_node_group_role_arn

  tags = merge(var.tags, {
    Environment = var.env
  })
}