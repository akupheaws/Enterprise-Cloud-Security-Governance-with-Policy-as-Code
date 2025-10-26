module "vpc" {
  source = "./modules/vpc"
  region = var.region
  cost_center = local.cost_center
}

module "s3" {
  source = "./modules/s3"
  region = var.region
  cost_center = local.cost_center
}

module "ec2" {
  source = "./modules/ec2"
  subnet_ids = module.vpc.public_subnets
  cost_center = local.cost_center
}

# Caller/account context
data "aws_caller_identity" "current" {}

# Region and partition for ARNs
data "aws_region" "current" {}
data "aws_partition" "current" {}
