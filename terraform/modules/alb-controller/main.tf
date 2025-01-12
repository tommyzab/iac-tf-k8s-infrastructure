resource "helm_release" "aws_lb_controller" {
  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.5.3"
  namespace  = var.namespace
  

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }

  set {
    name  = "awsRegion"
    value = var.region
  }
  set {
    name  = "rbac.create"
    value = "true"
  }
  set {
    name  = "serviceAccount.create"
    value = "true"
  }
 set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

}

resource "aws_iam_policy" "kubernetes_alb_controller" {
  name        = "${var.eks_cluster_name}-alb-controller"
  path        = "/"
  description = "Policy for load balancer controller service"

  policy = file("./modules/alb-controller/alb_controller_iam_policy.json")
}

# Role
data "aws_iam_policy_document" "kubernetes_alb_controller_assume" {

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.issuer]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.namespace}:aws-load-balancer-controller}",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.issuer, "https://", "")}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "kubernetes_alb_controller" {
  name               = "${var.eks_cluster_name}-alb-controller"
  assume_role_policy = data.aws_iam_policy_document.kubernetes_alb_controller_assume.json
}

resource "aws_iam_role_policy_attachment" "kubernetes_alb_controller" {
  role       = aws_iam_role.kubernetes_alb_controller.name
  policy_arn = aws_iam_policy.kubernetes_alb_controller.arn
}

