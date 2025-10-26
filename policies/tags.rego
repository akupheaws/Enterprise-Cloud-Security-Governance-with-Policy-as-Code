package policy.tags

# Deny resources missing mandatory CostCenter tag
deny[msg] {
  not input.resource.tags.CostCenter
  msg := sprintf("Resource %v missing CostCenter tag", [input.resource.name])
}

deny[msg] {
  input.resource.tags.CostCenter == ""
  msg := sprintf("Resource %v has an empty CostCenter tag", [input.resource.name])
}
