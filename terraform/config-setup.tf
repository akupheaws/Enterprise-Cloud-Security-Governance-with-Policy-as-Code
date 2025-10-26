# Unique suffix for the AWS Config logs bucket
resource "random_id" "config_logs_suffix" {
  byte_length = 3
}

# S3 bucket for AWS Config snapshots and configuration history
resource "aws_s3_bucket" "config_logs" {
  bucket = "config-logs-${var.region}-${random_id.config_logs_suffix.hex}"
  tags = {
    CostCenter = local.cost_center
  }
}

# Block public access to the Config logs bucket
resource "aws_s3_bucket_public_access_block" "config_logs" {
  bucket = aws_s3_bucket.config_logs.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Enable versioning on the Config logs bucket
resource "aws_s3_bucket_versioning" "config_logs" {
  bucket = aws_s3_bucket.config_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Default encryption for Config logs bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "config_logs" {
  bucket = aws_s3_bucket.config_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bucket policy that allows AWS Config to write with the required ACL
resource "aws_s3_bucket_policy" "config_logs" {
  bucket = aws_s3_bucket.config_logs.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AWSConfigBucketPermissionsCheck",
        Effect    = "Allow",
        Principal = { Service = "config.amazonaws.com" },
        Action    = "s3:GetBucketAcl",
        Resource  = "arn:${data.aws_partition.current.partition}:s3:::${aws_s3_bucket.config_logs.bucket}"
      },
      {
        Sid       = "AWSConfigBucketDelivery",
        Effect    = "Allow",
        Principal = { Service = "config.amazonaws.com" },
        Action    = "s3:PutObject",
        Resource  = "arn:${data.aws_partition.current.partition}:s3:::${aws_s3_bucket.config_logs.bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

# Create the service-linked role for AWS Config
resource "aws_iam_service_linked_role" "config" {
  aws_service_name = "config.amazonaws.com"
}

# Create the Configuration Recorder
resource "aws_config_configuration_recorder" "this" {
  name     = "default"
  role_arn = aws_iam_service_linked_role.config.arn
  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

# Delivery Channel without s3_key_prefix so Config uses AWSLogs/<account>/Config/
resource "aws_config_delivery_channel" "this" {
  name           = "default"
  s3_bucket_name = aws_s3_bucket.config_logs.bucket
  depends_on     = [aws_s3_bucket_policy.config_logs, aws_config_configuration_recorder.this]
}

# Start the Configuration Recorder
resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.this]
}
