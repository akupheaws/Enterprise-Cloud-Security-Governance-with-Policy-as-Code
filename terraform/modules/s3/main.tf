resource "aws_s3_bucket" "secure" {
  count  = 5
  bucket = "policy-secure-bucket-${count.index}"

  tags = {
    CostCenter = var.cost_center
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  count  = 5
  bucket = aws_s3_bucket_secure[count.index].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  count  = 5
  bucket = aws_s3_bucket_secure[count.index].id

  versioning_configuration {
    status = "Enabled"
  }
}
