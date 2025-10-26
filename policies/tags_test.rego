package policy.tags

test_missing_costcenter_is_denied {
  result := deny with input as {"resource":{"name":"app","tags":{}}}
  count(result) == 1
}

test_empty_costcenter_is_denied {
  result := deny with input as {"resource":{"name":"db","tags":{"CostCenter":""}}}
  count(result) == 1
}
