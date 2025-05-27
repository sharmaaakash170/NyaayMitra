resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.env}-eks-cluster-role"
  assume_role_policy = file("${path.module}/policy/eks_cluster_policy.json")

  tags = merge(var.tags, {
    Name = "${var.env}-eks-cluster-role"
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role" "eks_node_group_role" {
  name = "${var.env}-eks-node-group-role"
  assume_role_policy = file("${path.module}/policy/eks_nodegroup_policy.json")

  tags = merge(var.tags, {
    Name = "${var.env}-eks-node-group-role"
  })
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_policy" "alb_ingress_policy" {
  name = "AWSLoadBalancerControllerIAMPolicy"
  path = "/"
  policy = file("${path.module}/policy/iam-policy-alb-controller.json")
}

resource "aws_iam_role" "alb_ingress_role" {
  name = "${var.env}-alb-ingress-role"

  assume_role_policy = file("${path.module}/policy/eks_nodegroup_policy.json")
}

resource "aws_iam_role_policy_attachment" "alb_attach" {
  policy_arn = aws_iam_policy.alb_ingress_policy.arn
  role       = aws_iam_role.alb_ingress_role.name
}