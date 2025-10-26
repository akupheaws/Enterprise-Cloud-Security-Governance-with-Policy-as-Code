# Root Terraform settings: versions, providers, backend
terraform {
  required_version = ">= 1.4.0"

  # Single required_providers block
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.11"
    }
  }

  # Remote state backend
  backend "s3" {
    bucket         = "compliance-akuphe"
    key            = "gov-policy/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile = true
    # dynamodb_table = "terraform-locks" # enable after table exists
  }
}

# AWS provider
provider "aws" {
  region = var.region
}

# Deployment region variable
variable "region" {
  type        = string
  description = "AWS deployment region"
  default     = "us-east-1"
}

# Governance-required tag for FinOps + ownership tracking
locals {
  cost_center = "SecurityOps"
}
