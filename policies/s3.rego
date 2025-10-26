package policy.s3

# Deny public S3 buckets
deny[msg] {
  input.resource.type == "s3"
  input.resource.public == true
  msg := "Bucket must not be public"
}

# Deny buckets without versioning
deny[msg] {
  input.resource.type == "s3"
  input.resource.versioning != "Enabled"
  msg := "Bucket must have versioning enabled"
}
