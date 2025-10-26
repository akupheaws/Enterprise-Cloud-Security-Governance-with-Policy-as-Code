module "main_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "policy-as-code"
  cidr = "10.0.0.0/16"

  azs = ["us-east-1a","us-east-1b","us-east-1c","us-east-1d"]

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    CostCenter = var.cost_center
  }
}
