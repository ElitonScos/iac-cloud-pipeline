# iac-cloud-pipeline

Infrastructure as Code provisioning AWS resources with Terraform, plus a complete CI/CD pipeline, running entirely for free with no AWS account. Uses [LocalStack](https://localstack.cloud/) to emulate AWS locally, so the same Terraform code that runs here would run against real AWS by changing only the endpoint. Designed to demonstrate Terraform, AWS resource modeling, GitHub Actions CI/CD and container image security scanning.

---

## Architecture

```
git push
   │
   ▼
GitHub Actions
   lint  ──►  test  ──►  build  ──►  Trivy scan  ──►  push GHCR  ──►  terraform plan/apply
                                          │                                   │
                                          ▼                                   ▼
                                      GHCR registry                  LocalStack (AWS :4566)
                                                                   S3 · DynamoDB · SQS+DLQ
                                                                   IAM · VPC
```

---

## AWS resources provisioned

| Resource | File | Purpose |
|----------|------|---------|
| S3 (versioned + encrypted bucket) | `terraform/s3.tf` | Build artifacts, backups, static files |
| DynamoDB (2 tables) | `terraform/dynamodb.tf` | NoSQL data and Terraform state lock |
| SQS (queue + DLQ) | `terraform/sqs.tf` | Decoupling services, background processing |
| IAM (role + policy + profile) | `terraform/iam.tf` | Least privilege access for the app |
| VPC (subnets + IGW + route + SG) | `terraform/vpc.tf` | Isolated, segmented network |

---

## Stack

| Component | Technology | Role |
|-----------|-----------|------|
| IaC | Terraform 1.7 | Declarative infrastructure |
| Cloud (emulated) | LocalStack | AWS services on localhost, free |
| CI/CD | GitHub Actions | lint, test, build, scan, push, apply |
| Security | Trivy | Container image vulnerability scan |
| Registry | GHCR | Container image registry |
| App | Python (placeholder) | Demo service with Dockerfile |

---

## Getting Started

Requirements (all free): Docker, Terraform, AWS CLI.

```bash
git clone https://github.com/ElitonScos/iac-cloud-pipeline.git
cd iac-cloud-pipeline

bash scripts/localstack-up.sh
bash scripts/deploy.sh
bash scripts/validate.sh
```

Or via Makefile:
```bash
make up && make deploy && make validate
```

Tear everything down:
```bash
bash scripts/destroy.sh
```

---

## CI/CD Pipeline

Every push / PR to `main` runs four chained jobs:

1. **lint** — `terraform fmt -check` and `terraform validate`
2. **test** — start the app and smoke test `/health`
3. **build-scan-push** — build the Docker image, scan it with Trivy (CRITICAL/HIGH), push to GHCR (main only)
4. **terraform** — spin up LocalStack as a service and run `terraform plan/apply`

To fail the build on vulnerabilities, change `exit-code: "0"` to `"1"` in the Trivy step.

---

## Scripts

| Script | Description |
|--------|-------------|
| `scripts/localstack-up.sh` | Start LocalStack and wait until healthy |
| `scripts/deploy.sh` | terraform init / validate / plan / apply |
| `scripts/validate.sh` | List the created resources via AWS CLI |
| `scripts/destroy.sh` | Destroy infrastructure and stop LocalStack |

---

## Project Structure

```
iac-cloud-pipeline/
├── app/                      — placeholder service + Dockerfile
├── terraform/
│   ├── main.tf               — AWS provider pointed at LocalStack
│   ├── variables.tf
│   ├── outputs.tf
│   ├── s3.tf
│   ├── dynamodb.tf
│   ├── sqs.tf
│   ├── iam.tf
│   └── vpc.tf
├── scripts/                  — localstack-up, deploy, validate, destroy
├── .github/workflows/ci-cd.yml
├── docker-compose.yml        — app + LocalStack
├── Makefile
└── README.md
```

---

## Running against real AWS

The Terraform is real AWS code. To run it in the cloud, remove the `endpoints` block and the `skip_*` flags from `terraform/main.tf` and configure real credentials. Nothing else changes.
