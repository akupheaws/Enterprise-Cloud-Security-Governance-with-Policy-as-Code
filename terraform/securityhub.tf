# Enable Security Hub for this account
resource "aws_securityhub_account" "this" {}

# Short wait to avoid eventual consistency issues
resource "time_sleep" "wait_for_securityhub" {
  depends_on      = [aws_securityhub_account.this]
  create_duration = "20s"
}

# Subscribe to CIS Foundations using the region-qualified ARN
resource "aws_securityhub_standards_subscription" "cis" {
  standards_arn = "arn:${data.aws_partition.current.partition}:securityhub:${data.aws_region.current.name}::standards/cis-aws-foundations-benchmark/v/1.2.0"
  depends_on    = [time_sleep.wait_for_securityhub]
}
