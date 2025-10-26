package policy.tags

test_tags_missing {
  result := deny with input as {"resource":{"name":"bad","tags":{"CostCenter":""}}}
  count(result) > 0
}
