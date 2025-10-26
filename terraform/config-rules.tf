# Detect public S3 buckets
resource "aws_config_config_rule" "s3_no_public" {
  name = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }
  depends_on = [aws_config_configuration_recorder_status.this]
}

# Detect S3 buckets without versioning enabled
resource "aws_config_config_rule" "s3_versioning_enabled" {
  name = "S3_BUCKET_VERSIONING_ENABLED"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_VERSIONING_ENABLED"
  }
  depends_on = [aws_config_configuration_recorder_status.this]
}
