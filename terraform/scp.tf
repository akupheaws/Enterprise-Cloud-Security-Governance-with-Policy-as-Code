# Toggle to enable SCP resources when in an AWS Organization
variable "enable_organizations" {
  type        = bool
  description = "Enable SCPs if the account is in an AWS Organization"
  default     = false
}

resource "aws_organizations_policy" "allowed_regions" {
  count = var.enable_organizations ? 1 : 0

  name = "DenyNonUSEast1"
  type = "SERVICE_CONTROL_POLICY"
  content = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Deny",
    "Action": "*",
    "Resource": "*",
    "Condition": {
      "StringNotEquals": { "aws:RequestedRegion": ["us-east-1"] }
    }
  }]
}
EOF
}
