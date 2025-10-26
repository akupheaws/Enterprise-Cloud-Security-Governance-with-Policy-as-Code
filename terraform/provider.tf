terraform {
  #Remote state backend for consistency
  backend "s3" {
    bucket = "YOUR-STATE-BUCKET"
    key    = "gov-policy/terraform.tfstate"
    region = "us-east-1"
  }

  required_version = ">= 1.4.0"
}

provider "aws" {
  region = "us-east-1"
}

locals {
  # Governance-required tag for FinOps + ownership tracking
  cost_center = "SecurityOps"
}
