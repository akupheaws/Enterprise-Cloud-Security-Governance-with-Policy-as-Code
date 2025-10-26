# Caller/account context
data "aws_caller_identity" "current" {}

# Region and partition for ARNs
data "aws_region" "current" {}
data "aws_partition" "current" {}
