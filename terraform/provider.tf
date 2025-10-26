terraform {
  #Remote state backend for consistency
  backend "s3" {
    bucket = "compliance-akuphe"
    key    = "gov-policy/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
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

# In terraform/main.tf or a providers file
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# In terraform/main.tf or a providers file
terraform {
  required_providers {
    time = {
      source  = "hashicorp/time"
      version = "~> 0.11"
    }
  }
}

