package policy.s3

# Deny public S3 bucket access
deny[msg] if {
  input.resource.type == "s3"
  input.resource.public == true
} then {
  msg := "Bucket is public; must be private"
}

# Deny if versioning is not enabled
deny[msg] if {
  input.resource.type == "s3"
  input.resource.versioning != "Enabled"
} then {
  msg := "Bucket missing versioning"
}
