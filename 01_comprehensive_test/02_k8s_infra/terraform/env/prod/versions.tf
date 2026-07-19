terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.86.0" # 將版本鎖定在 v5 的最新穩定版，避開 v6
    }
  }
}