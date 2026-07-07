# Development environment S3 configuration
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/s3"
}

inputs = {
  environment  = "development"
  owner        = "dev-team"
  project      = "simple-tg"
  bucket_name  = "test-iac-dev-bucket-unique"
  access_key   = "AKIADEVEXAMPLE123"
  aws_region   = "us-east-1"
}
