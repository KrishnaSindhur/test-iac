#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
ENV="${1:-dev}"

cd "$ROOT"

echo "=== terragrunt run-all plan (env=$ENV) ==="
terragrunt run-all plan --terragrunt-working-dir "environments/$ENV"

echo ""
echo "=== terragrunt run-all apply (env=$ENV) ==="
echo "Uncomment the line below to apply:"
echo "terragrunt run-all apply --terragrunt-working-dir environments/$ENV"
