# Development environment EC2 configuration
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/ec2"
}

inputs = {
  environment   = "development"
  owner         = "dev-team"
  project       = "simple-tg"
  instance_type = "t2.small"
  bucket_name   = "test-iac-dev-bucket-default"
  db_password   = "DevPassword123!"
  aws_region    = "us-west-1"
}
