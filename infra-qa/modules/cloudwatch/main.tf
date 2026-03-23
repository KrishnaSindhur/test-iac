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

# Deprecated empty provider block - triggers warning in OpenTofu
provider "aws" {
}

# Another aliased empty provider block
provider "aws" {
  alias = "monitoring_cluster"
}

resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/app/logs"
  retention_in_days = 7

  tags = {
    Environment = "qa"
    Application = "demo"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "high-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm monitors EC2 CPU utilization"

  dimensions = {
    AutoScalingGroupName = "demo-asg"
  }
}
