# Enterprise Cloud Security Governance with Policy-as-Code

**Description & Why it matters**  
This project delivers an end-to-end, **financial-grade cloud governance platform** for AWS that enforces security by design using **Policy-as-Code**. It blocks non-compliant infrastructure changes in CI/CD with **OPA/Rego** and **Conftest**, continuously monitors the environment with **AWS Config** and **Security Hub**, and auto-remediates drift using AWS-native controls. For regulated organizations (e.g., banking, healthcare), this approach reduces risk, proves compliance, and keeps cloud environments **secure, auditable, and self-healing**.

---

## Key capabilities

- Preventative controls: OPA/Rego unit tests + Conftest scan of `tfplan.json` in GitHub Actions  
- Detective controls: AWS Config (recorder + rules + Conformance Pack) + Security Hub standards  
- Auto-hardening: S3 public access blocks, versioning, encrypted logs bucket for Config  
- Organizational guardrails (optional): SCPs (only when the account is in AWS Organizations)  
- Enterprise IaC: Modular Terraform (VPC, S3, EC2) with governance tags and multi-AZ layout  
- Pipeline quality: Multi-job workflow (tests → plan → policy check → gated apply)

---

## Architecture (Prevent → Detect → Correct → Verify)

```
Developer Commit
      │
      ▼
GitHub Actions
  - OPA unit tests (Rego)
  - Terraform plan → tfplan.json
  - Conftest policy check (deny on violations)
  - Apply previously validated plan
      │
      ▼
AWS Environment
  - AWS Config recorder, delivery channel, conformance pack
  - Security Hub (CIS v1.4.0 by default)
  - Secure S3 (PAB + versioning)
  - Optional SCPs
      │
      ▼
Continuous Compliance & Audit-Readiness
```

---

## Repository layout

```
.
├── .github/workflows/
│   └── secure-deploy.yml
├── policies/
│   ├── s3.rego
│   ├── s3_test.rego
│   ├── tags.rego
│   ├── tags_test.rego
│   └── tfplan.rego
└── terraform/
    ├── main.tf
    ├── variables.tf
    ├── provider.tf (or merged into main.tf)
    ├── data.tf
    ├── vpc.tf / modules/vpc/*
    ├── s3.tf / modules/s3/*
    ├── ec2.tf / modules/ec2/*
    ├── config-setup.tf
    ├── config-rules.tf
    ├── conformance-pack.tf
    ├── securityhub.tf
    ├── scp.tf (optional)
    └── outputs.tf
```

---

## Prerequisites

- Terraform ≥ 1.4  
- AWS credentials with permissions to create VPC, EC2, S3, IAM Service-Linked Roles, Config, Security Hub  
- S3 bucket for Terraform remote state (configured in backend)  
- (Optional) DynamoDB table for state locking

---

## Environment variables (local or GitHub Actions → Secrets)

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION=us-east-1
```

Optional Terraform variable overrides:

```
TF_VAR_region=us-east-1
TF_VAR_cis_version=1.4.0
TF_VAR_enable_organizations=true  # only if you're in AWS Organizations
```

---

## Quick start (local)

```bash
cd terraform
terraform init
terraform plan -out=tfplan
terraform show -json tfplan > tfplan.json
# Optionally run conftest locally if installed:
# conftest test -p ../policies tfplan.json
terraform apply -input=false tfplan
```

---

## CI/CD (multi-job workflow)

- **opa-tests**: `opa test policies/` (unit tests for Rego logic)  
- **terraform-plan**: `terraform plan` → `tfplan.json` exported as artifact  
- **policy-check**: `conftest test -p policies tfplan.json` denies on violations  
- **terraform-apply**: applies the **previously validated** plan on `main`

> Add approvals via GitHub Environments for production change control.

---

## Terraform modules

- **VPC**: 4 AZs, 8 public + 8 private subnets, IGW, single NAT (cost-aware)  
- **S3**: 5 buckets, **Public Access Block** + **Versioning** enforced  
- **EC2**: 4 instances across public subnets (demo workload)  
- **Governance tags**: `CostCenter=SecurityOps` (customizable)

---

## Policy-as-Code (OPA/Rego)

- **Unit tests** (`s3_test.rego`, `tags_test.rego`) validate rule behavior
- **Runtime enforcement** (`tfplan.rego`) inspects `tfplan.json` to ensure:
  - Each new S3 bucket has a matching **Public Access Block** resource  
  - S3 **Versioning** is enabled  
  - **CostCenter** tag exists and is non-empty on created/updated resources

If policy denies, the pipeline **fails before** any AWS changes.

---

## AWS Config & Security Hub

- `config-setup.tf` creates:
  - **Config logs bucket** (encrypted, versioned, PAB, bucket policy granting `config.amazonaws.com`)  
  - **Configuration Recorder** and **Delivery Channel**  
  - Recorder **started** before any rules or conformance packs

- `config-rules.tf` includes key AWS managed rules:
  - `S3_BUCKET_PUBLIC_READ_PROHIBITED`  
  - `S3_BUCKET_VERSIONING_ENABLED`  

- `conformance-pack.tf`: bundles multiple rules (CIS-aligned) for centralized reporting

- `securityhub.tf`: enables Security Hub, then subscribes to **CIS v1.4.0** via a region-qualified ARN  
  - If your region doesn’t support the CIS version, switch to **AWS Foundational Security Best Practices** standard

---

## Optional: SCPs (Service Control Policies)

- Disabled by default unless `enable_organizations=true` (avoids errors when not in an Org)  
- Example SCP: deny non-`us-east-1` region usage

---

## Cost considerations

- **NAT Gateway** has hourly and data processing costs. For demos, keep `single_nat_gateway = true` or disable NAT if not needed.
- EC2 and S3 incur ongoing costs; destroy when done.

---

## Cleanup

```bash
terraform -chdir=terraform destroy -auto-approve
```

---

## Troubleshooting

**NoAvailableConfigurationRecorder** when creating rules or conformance pack  
• Ensure the **Configuration Recorder**, **Delivery Channel**, and **Recorder Status (enabled)** are created first.  
• In this repo, rules/packs `depends_on` recorder status.

**InsufficientDeliveryPolicyException** for Config delivery channel  
• Use the provided **bucket policy** and **omit** `s3_key_prefix` (Config writes to `AWSLogs/<account>/Config/` automatically).

**Security Hub InvalidInputException** for standards ARN  
• Use a **region-qualified** ARN and a supported **CIS version** (default `1.4.0`).  
• If still failing, switch to **AWS Foundational Security Best Practices** ARN.

**OrganizationsNotInUseException** for SCPs  
• Leave `enable_organizations=false` unless the account is in an AWS Organization.

---

## Demo: break-glass tests

- Remove `CostCenter` in a Terraform resource → **Conftest deny** before deploy  
- Disable S3 Versioning in code → **Conftest deny** before deploy  
- Manually make an S3 bucket public → **AWS Config** flags non-compliance (and Security Hub surfaces it)

---

## Why this is important (talking points)

- **Prevention first**: security gates run **before** infrastructure is deployed  
- **Continuous assurance**: AWS Config and Security Hub provide live compliance posture  
- **Audit-ready**: controls trace to CIS; findings and history are centralized  
- **Operational excellence**: clear pipeline stages, least-privilege, optional approvals  
- **Scalable governance**: modules, tags, and optional SCPs enable multi-account scale

---

## Roadmap ideas

- Replace static AWS keys with **OIDC** for GitHub → AWS (no long-lived secrets)  
- Centralize multi-account findings (Security Hub + Config Aggregators)  
- Auto-remediation runbooks (SSM Automation via EventBridge)  
- Add GuardDuty, CloudTrail org trails, and conformant logging architecture

---

**License**: MIT (or your choice)  
**Maintainer**: Akuphe (Cloud & DevOps Engineer)
