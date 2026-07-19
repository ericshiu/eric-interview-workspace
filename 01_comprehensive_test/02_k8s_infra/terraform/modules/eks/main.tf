# modules/eks/main.tf
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.0.0"

  cluster_name    = var.cluster_name
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids

  # 啟用 CSI Driver 確保 PVC 可以自動掛載 EBS
  cluster_addons = {
    vpc-cni            = {}
    coredns            = {}
    aws-ebs-csi-driver = { most_recent = true }
  }

  eks_managed_node_groups = {
    main = {
      min_size     = var.node_group_min_size
      max_size     = var.node_group_max_size
      desired_size = var.node_group_desired_size
    }
  }
}