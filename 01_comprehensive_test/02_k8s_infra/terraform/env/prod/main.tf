# terraform/env/prod/main.tf

provider "aws" {
  region                      = "ap-northeast-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2            = "http://localhost:4566"
    eks            = "http://localhost:4566"
    iam            = "http://localhost:4566"
    sts            = "http://localhost:4566"
    kms            = "http://localhost:4566"
  }
}

# 1. 呼叫 VPC 模組
module "vpc" {
  source = "../../modules/vpc"
  
  # 傳遞參數以實現高可用
  cidr            = "10.0.0.0/16"
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# 2. 呼叫 EKS 模組
module "eks" {
  source = "../../modules/eks"
  
  # 依賴 VPC 模組的輸出
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  cluster_name    = "asiayo-prod-cluster"
  
  # 設定節點群組以確保高可用
  node_group_min_size     = 3
  node_group_max_size     = 6
  node_group_desired_size = 3
}