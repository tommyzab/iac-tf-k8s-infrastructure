resource "aws_iam_role" "eks-iam-role" {
 name = "${var.prefix}-eks-iam-role"
 path = "/"
 assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Principal": {
    "Service": "eks.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
  }
 ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "demo-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-iam-role.name
}

resource "aws_iam_role_policy_attachment" "demo-ALBIngressControllerIAMPolicy" {
  policy_arn = "arn:aws:iam::292029882946:policy/ALBIngressControllerIAMPolicy"
  role       = aws_iam_role.eks-iam-role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-iam-role.name
}


resource "aws_eks_cluster" "eks-cluster" {
  name     = "${var.prefix}-eks-cluster"
  role_arn = aws_iam_role.eks-iam-role.arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access = true
    subnet_ids = var.private_subnet_ids
  }
}

data "tls_certificate" "certificate" {
  url = aws_eks_cluster.eks-cluster.identity.0.oidc.0.issuer
}
### OIDC config
resource "aws_iam_openid_connect_provider" "eks-cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.certificate.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks-cluster.identity.0.oidc.0.issuer
}



resource "aws_iam_role" "nodes" {
  name = "eks-node-group-nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_policy" "nodes-Policy" {
  name        = "node-Policy"
  path        = "/"
  description = "Policy for worker nodes"

  policy = file("iam-policy.json")
}

resource "aws_iam_role_policy_attachment" "nodes-attachment" {
  role       = aws_iam_role.nodes.name
  policy_arn = aws_iam_policy.nodes-Policy.arn
}


resource "aws_iam_role_policy_attachment" "nodes-ElasticLoadBalancingPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids = var.private_subnet_ids
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]


  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }


}


resource "aws_eks_addon" "addon" {
  depends_on        = [aws_eks_node_group.private-nodes]
  # for_each          = { for addon in var.addons : addon.name => addon }
  cluster_name      = aws_eks_cluster.eks-cluster.id
  addon_name        = var.addon_name
  addon_version     = var.addon_version
}


resource "kubernetes_namespace" "monitoring-namespace" {
    metadata {
    name = var.monitoring_namespace
  }
}

resource "kubernetes_namespace" "argocd-namespace" {
    metadata {
    name = var.argocd_namespace
  }
}
