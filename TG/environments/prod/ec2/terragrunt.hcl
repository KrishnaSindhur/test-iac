# Production environment EC2 configuration
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/ec2"
}

inputs = {
  environment   = "production"
  owner         = "prod-team"
  project       = "enterprise-app"
  instance_type = "t2.small"
  bucket_name   = "test-iac-prod-bucket-default"
  db_password   = "ProdPassword456!"
  aws_region    = "us-west-1"
}
