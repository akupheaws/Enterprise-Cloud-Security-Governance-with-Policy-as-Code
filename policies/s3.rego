package policy.s3

# deny is a set of strings with human-readable messages
deny is set of string

# Bucket must not be public
deny contains msg if {
  input.resource.type == "s3"
  input.resource.public == true
  msg := "Bucket must not be public"
}

# Versioning must be enabled
deny contains msg if {
  input.resource.type == "s3"
  input.resource.versioning != "Enabled"
  msg := "Bucket must have versioning enabled"
}
