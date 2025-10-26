# Detect if bucket becomes public
resource "aws_config_config_rule" "s3_no_public" {
  name = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }
}

# Detect if versioning is disabled
resource "aws_config_config_rule" "s3_versioning_enabled" {
  name = "S3_BUCKET_VERSIONING_ENABLED"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_VERSIONING_ENABLED"
  }
}
