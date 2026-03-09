locals {
  cluster_name = "${var.environment}-${var.application}-eks-cluster"
}

resource "aws_iam_role" "cluster" {
  name = "${var.environment}-${var.application}-eks-cluster-role"
  path = "/"

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.application}-eks-cluster-role"
  })

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "alb_ingress_policy" {
  count      = var.alb_ingress_policy_arn != "" ? 1 : 0
  policy_arn = var.alb_ingress_policy_arn
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "ecr_read_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.cluster.name
}

resource "aws_eks_cluster" "main" {
  name     = local.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = "1.27"

  tags = merge(var.common_tags, {
    Name = local.cluster_name
  })

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.alb_ingress_policy,
  ]
}

data "tls_certificate" "certificate" {
  url = aws_eks_cluster.main.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "main" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.certificate.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity.0.oidc.0.issuer
}

resource "aws_iam_role" "node" {
  name = "${var.environment}-${var.application}-eks-node-role"

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.application}-eks-node-role"
  })

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.environment}-${var.application}-eks-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  depends_on = [
    aws_iam_role_policy_attachment.node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.node_ecr_policy,
  ]
}

resource "aws_eks_addon" "addon" {
  depends_on    = [aws_eks_node_group.main]
  cluster_name  = aws_eks_cluster.main.id
  addon_name    = var.addon_name
  addon_version = var.addon_version
}
