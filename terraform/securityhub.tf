# Enable Security Hub for this account
resource "aws_securityhub_account" "this" {}

# Small wait to avoid eventual consistency before enabling standards
resource "time_sleep" "wait_for_securityhub" {
  depends_on      = [aws_securityhub_account.this]
  create_duration = "20s"
}

# Subscribe to CIS Foundations with region-qualified ARN and version variable
resource "aws_securityhub_standards_subscription" "cis" {
  standards_arn = "arn:${data.aws_partition.current.partition}:securityhub:${data.aws_region.current.name}::standards/cis-aws-foundations-benchmark/v/${var.cis_version}"
  depends_on    = [time_sleep.wait_for_securityhub]
}
