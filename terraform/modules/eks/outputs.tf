output "eks_cluster_name" {
  value = aws_eks_cluster.eks-cluster.name
}

# output "service_account_name" {
#   value = aws_eks_service_account.aws_load_balancer_controller.name
# }

output "open_id_issuer" {
  value = aws_iam_openid_connect_provider.eks-cluster.arn
}
