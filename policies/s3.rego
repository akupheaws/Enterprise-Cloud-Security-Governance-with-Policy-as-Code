package policy.s3

# Ensure S3 buckets are private
deny[msg] {
  input.resource.type == "s3"
  input.resource.public == true
  msg = "Bucket is public; must be private"
}

# Ensure Versioning
deny[msg] {
  input.resource.type == "s3"
  input.resource.versioning != "Enabled"
  msg = "Bucket missing versioning"
}
