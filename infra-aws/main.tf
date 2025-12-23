terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# S3 bucket module - called once
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.0.0"

  bucket = "demo-app-bucket-${random_id.bucket_suffix.hex}"
  acl    = "private"

  versioning = {
    enabled = true
  }

  tags = {
    Environment = "demo"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# EC2 module - called 3 times (3 invocations)
module "ec2_web" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  name = "web-server"

  instance_type = "t2.micro"
  ami           = var.ami_id

  tags = {
    Role = "web"
  }
}

module "ec2_app" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  name = "app-server"

  instance_type = "t2.micro"
  ami           = var.ami_id

  tags = {
    Role = "app"
  }
}

module "ec2_db" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  name = "db-server"

  instance_type = "t2.small"
  ami           = var.ami_id

  tags = {
    Role = "database"
  }
}

# Security group module - called 2 times (2 invocations)
module "sg_web" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "web-sg"
  description = "Security group for web servers"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
}

module "sg_db" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "db-sg"
  description = "Security group for database"

  ingress_cidr_blocks = ["10.0.0.0/16"]
  ingress_rules       = ["mysql-tcp"]
}