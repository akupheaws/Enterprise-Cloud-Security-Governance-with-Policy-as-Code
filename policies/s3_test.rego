package policy.s3

test_public_bucket_denied {
  result := deny with input as {"resource":{"type":"s3","public":true,"versioning":"Enabled"}}
  count(result) == 1
}

test_versioning_required {
  result := deny with input as {"resource":{"type":"s3","public":false,"versioning":"Disabled"}}
  count(result) == 1
}
