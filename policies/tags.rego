package policy.tags

deny[msg] {
  input.resource.tags.CostCenter == ""
  msg = sprintf("Resource %v missing CostCenter tag", [input.resource.name])
}
