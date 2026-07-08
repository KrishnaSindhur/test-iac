include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/app"
}

inputs = {
  project        = "test-iac-tg1"
  instance_count = 2
  instance_type  = "t2.small"
  aws_region     = "us-west-1"
}
