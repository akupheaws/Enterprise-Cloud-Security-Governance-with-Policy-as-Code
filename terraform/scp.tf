resource "aws_organizations_policy" "allowed_regions" {
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
