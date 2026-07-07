# Root Terragrunt configuration (referenced by child modules via find_in_parent_folders)
# State: omit remote_state so Harness IaCM manages backend/state automatically.

locals {
  # TG/environments/{dev|prod}/{module} -> auto-picks testOverrideFiles/{dev|prod}.tfvars
  environment = basename(dirname(get_terragrunt_dir()))
  tfvars_file = "${get_parent_terragrunt_dir()}/testOverrideFiles/${local.environment}.tfvars"
}

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
  region = "us-east-1"

  default_tags {
    tags = {
      ManagedBy = "Terragrunt"
    }
  }
}
EOF
}

terraform {
  extra_arguments "auto_var_file" {
    commands = [
      "plan",
      "apply",
      "destroy",
      "refresh",
      "import",
    ]
    arguments = [
      "-var-file=${local.tfvars_file}",
    ]
  }

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
