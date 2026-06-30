#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR/terraform"

terraform init -input=false
terraform validate
terraform plan -input=false -out=tfplan
terraform apply -input=false tfplan

terraform output
