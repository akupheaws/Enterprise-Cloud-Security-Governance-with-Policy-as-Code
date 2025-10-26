package policy.s3

# Public bucket is denied
test_public_bucket_denied if {
  result := data.policy.s3.deny with input as {
    "resource": {"type": "s3", "public": true, "versioning": "Enabled"}
  }
  count(result) == 1
}

# Missing versioning is denied
test_versioning_required if {
  result := data.policy.s3.deny with input as {
    "resource": {"type": "s3", "public": false, "versioning": "Disabled"}
  }
  count(result) == 1
}
