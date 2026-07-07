# Parent config only — NOT run as a module (root.hcl is excluded from run-all).
# Variables are set per-environment in environments/*/terragrunt.hcl inputs blocks.
# State: no remote_state block — Harness IaCM manages backend/state automatically.

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"

  default_tags {
    tags = {
      ManagedBy = "Terragrunt"
    }
  }
}
EOF
}
