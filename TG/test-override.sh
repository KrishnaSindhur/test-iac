#!/bin/bash
set -euo pipefail

echo "=== Testing Terragrunt (tfvars auto-loaded from TG/testOverrideFiles/) ==="

cd "$(dirname "$0")/environments/dev/s3"

echo "1. Clean up cache..."
rm -rf .terragrunt-cache

echo "2. Initialize..."
terragrunt init

echo "3. Plan (dev.tfvars applied automatically)..."
terragrunt plan

echo "4. Plan with CLI owner override (overrides tfvars)..."
terragrunt plan -var="owner=raj-custom-owner"

echo "=== Test completed ==="
