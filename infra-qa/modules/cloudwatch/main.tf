# Cloudwatch monitoring module with deprecated empty provider blocks
# This pattern triggers the "Redundant empty provider block" warning

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Deprecated empty provider block - triggers warning in OpenTofu validate
provider "aws" {
}

# Another aliased empty provider block  
provider "aws" {
  alias = "monitoring_cluster"
}

# Local-only resources that don't require AWS API calls
variable "environment" {
  type    = string
  default = "qa"
}

locals {
  log_group_name = "/app/${var.environment}/logs"
  alarm_config = {
    name      = "high-cpu-utilization"
    threshold = 80
  }
}

output "log_group_name" {
  value = local.log_group_name
}

output "alarm_config" {
  value = local.alarm_config
}
