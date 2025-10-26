package policy.tfplan

deny[msg] {
  bucket_count := count([r |
    r := input.resource_changes[_]
    r.type == "aws_s3_bucket"
    r.change.actions[_] == "create"
  ])
  pab_count := count([r |
    r := input.resource_changes[_]
    r.type == "aws_s3_bucket_public_access_block"
    r.change.actions[_] == "create"
  ])
  pab_count < bucket_count
  msg := sprintf("All S3 buckets must have Public Access Block: buckets=%v, pab=%v", [bucket_count, pab_count])
}

deny[msg] {
  bucket_count := count([r |
    r := input.resource_changes[_]
    r.type == "aws_s3_bucket"
    r.change.actions[_] == "create"
  ])
  ver_enabled := count([r |
    r := input.resource_changes[_]
    r.type == "aws_s3_bucket_versioning"
    r.change.actions[_] == "create"
    r.change.after.versioning_configuration.status == "Enabled"
  ])
  ver_enabled < bucket_count
  msg := sprintf("All S3 buckets must enable versioning: buckets=%v, versioning_enabled=%v", [bucket_count, ver_enabled])
}

deny[msg] {
  r := input.resource_changes[_]
  some a
  a := r.change.actions[_]
  a == "create" or a == "update"
  r.change.after.tags
  not r.change.after.tags.CostCenter
  msg := sprintf("%v missing CostCenter tag", [r.address])
}

deny[msg] {
  r := input.resource_changes[_]
  some a
  a := r.change.actions[_]
  a == "create" or a == "update"
  r.change.after.tags.CostCenter == ""
  msg := sprintf("%v has empty CostCenter tag", [r.address])
}
