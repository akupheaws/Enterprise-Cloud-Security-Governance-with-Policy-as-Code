package policy.s3

test_public_bucket {
  result := deny with input as {"resource":{"type":"s3","public":true,"versioning":"Enabled"}}
  count(result) == 1
}
