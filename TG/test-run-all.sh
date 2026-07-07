#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
ENV="${1:-dev}"

cd "$ROOT"

echo "=== terragrunt plan --all (env=$ENV) ==="
cd "environments/$ENV"
terragrunt plan --all --non-interactive

echo ""
echo "=== terragrunt apply --all (env=$ENV) ==="
echo "Uncomment the line below to apply:"
echo "cd environments/$ENV && terragrunt apply --all --non-interactive"
