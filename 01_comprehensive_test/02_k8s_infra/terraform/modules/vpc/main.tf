# modules/vpc/main.tf
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "asiayo-vpc"
  cidr = var.cidr

  # 確保橫跨 3 個 AZ，達到高可用
  azs             = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway     = true
  one_nat_gateway_per_az = true # 每個 AZ 獨立 NAT，避免單點故障
}
