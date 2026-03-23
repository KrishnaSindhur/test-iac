# Additional locals to add complexity without AWS API calls
locals {
  role_config = {
    name = "cloudwatch-monitoring-role"
    policy_arns = [
      "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
    ]
  }
}
