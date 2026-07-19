# modules/eks/outputs.tf
output "cluster_name" {
  value = module.eks.cluster_name
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider (Required for IRSA)"
  value       = module.eks.oidc_provider_arn
}