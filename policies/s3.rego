package policy.s3

deny[msg] {
  input.resource.type == "s3"
  input.resource.public == true
  msg := "Bucket must not be public"
}

deny[msg] {
  input.resource.type == "s3"
  input.resource.versioning != "Enabled"
  msg := "Bucket must have versioning enabled"
}
