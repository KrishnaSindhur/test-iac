# Root Terragrunt configuration (referenced by child modules via find_in_parent_folders)
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

terraform {
  extra_arguments "init_args" {
    commands = ["init"]
    arguments = [
      "-reconfigure"
    ]
  }

  extra_arguments "plan_args" {
    commands = ["plan"]
    arguments = [
      "-refresh=true"
    ]
  }
}
