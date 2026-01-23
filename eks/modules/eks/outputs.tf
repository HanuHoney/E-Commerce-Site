output "cluster_id" {
  description = "The name/id of the EKS cluster"
  value       = aws_eks_cluster.main.id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = aws_eks_cluster.main.arn
}

output "cluster_endpoint" {
  description = "Endpoint for your EKS Kubernetes API"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
  sensitive   = true
}

output "cluster_version" {
  description = "The Kubernetes server version for the cluster"
  value       = aws_eks_cluster.main.version
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "node_group_id" {
  description = "The name of the EKS Node Group"
  value       = aws_eks_node_group.main.node_group_name
}

output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = aws_eks_node_group.main.arn
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = aws_eks_node_group.main.status
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = aws_iam_role.cluster.arn
}

output "node_iam_role_arn" {
  description = "IAM role ARN of the EKS node group"
  value       = aws_iam_role.node.arn
}
