resource "aws_instance" "web" {
  count         = 4
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_ids[count.index]

  tags = {
    CostCenter = var.cost_center
  }
}
