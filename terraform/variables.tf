# AWS deployment region
variable "region" {
  type        = string
  description = "AWS deployment region"
  default     = "us-east-1"
}

# CIS AWS Foundations Benchmark version for Security Hub
variable "cis_version" {
  type        = string
  description = "CIS AWS Foundations Benchmark version for Security Hub"
  default     = "1.4.0"
}
