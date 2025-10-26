package policy.tags

# Deny if CostCenter tag is missing or empty
deny[msg] if {
  input.resource.tags.CostCenter == ""
} then {
  msg := sprintf("Resource %v missing CostCenter tag", [input.resource.name])
}
