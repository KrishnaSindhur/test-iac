#!/bin/bash
set -euo pipefail

echo "=== Testing Terragrunt variable inputs from environments/dev/s3/terragrunt.hcl ==="

cd "$(dirname "$0")/environments/dev/s3"

echo "1. Clean up cache..."
rm -rf .terragrunt-cache

echo "2. Initialize..."
terragrunt init

echo "3. Plan (uses inputs from terragrunt.hcl)..."
terragrunt plan

echo "4. Plan with CLI owner override..."
terragrunt plan -var="owner=raj-custom-owner"

echo "=== Test completed ==="
