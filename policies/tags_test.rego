package policy.tags

# Missing CostCenter is denied
test_missing_costcenter_is_denied if {
  result := data.policy.tags.deny with input as {
    "resource": {"name": "app", "tags": {}}
  }
  count(result) == 1
}

# Empty CostCenter is denied
test_empty_costcenter_is_denied if {
  result := data.policy.tags.deny with input as {
    "resource": {"name": "db", "tags": {"CostCenter": ""}}
  }
  count(result) == 1
}
