resource "aws_config_conformance_pack" "cis_conformance" {
  name          = "CIS-AWS-Foundations-Benchmark"
  template_body = <<EOF
---
Resources:
  S3BucketPublicReadProhibited:
    Type: "AWS::Config::ConfigRule"
    Properties:
      ConfigRuleName: "S3_BUCKET_PUBLIC_READ_PROHIBITED"
      Source:
        Owner: "AWS"
        SourceIdentifier: "S3_BUCKET_PUBLIC_READ_PROHIBITED"

  S3BucketVersioningEnabled:
    Type: "AWS::Config::ConfigRule"
    Properties:
      ConfigRuleName: "S3_BUCKET_VERSIONING_ENABLED"
      Source:
        Owner: "AWS"
        SourceIdentifier: "S3_BUCKET_VERSIONING_ENABLED"

  IAMUserMFAEnabled:
    Type: "AWS::Config::ConfigRule"
    Properties:
      ConfigRuleName: "IAM_USER_MFA_ENABLED"
      Source:
        Owner: "AWS"
        SourceIdentifier: "IAM_USER_MFA_ENABLED"

  RootAccountMFAEnabled:
    Type: "AWS::Config::ConfigRule"
    Properties:
      ConfigRuleName: "ROOT_ACCOUNT_MFA_ENABLED"
      Source:
        Owner: "AWS"
        SourceIdentifier: "ROOT_ACCOUNT_MFA_ENABLED"

  CloudTrailEnabled:
    Type: "AWS::Config::ConfigRule"
    Properties:
      ConfigRuleName: "CLOUD_TRAIL_ENABLED"
      Source:
        Owner: "AWS"
        SourceIdentifier: "CLOUD_TRAIL_ENABLED"
EOF

  depends_on = [aws_config_configuration_recorder_status.this]
}
