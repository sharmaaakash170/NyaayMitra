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
  service_account_role_arn = aws_iam_role.ebs_csi_driver_irsa_role.arn
  tags = merge(var.tags, {
    Environment = var.env
  })
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd40f78"]
  url = aws_eks_cluster.this.identity.0.oidc.0.issuer
}

resource "aws_iam_role" "ebs_csi_driver_irsa_role" {
  name = "${var.env}-ebs-csi-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.irsa_assume_role.json
  tags = var.tags
}

data "aws_iam_policy_document" "irsa_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.this.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_irsa_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_driver_irsa_role.name
}

