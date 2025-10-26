package policy.tags

# Missing CostCenter tag
deny contains msg if {
  not input.resource.tags.CostCenter
  msg := sprintf("Resource %v missing CostCenter tag", [input.resource.name])
}

# Empty CostCenter tag
deny contains msg if {
  input.resource.tags.CostCenter == ""
  msg := sprintf("Resource %v has an empty CostCenter tag", [input.resource.name])
}
