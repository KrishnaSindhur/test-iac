terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# S3 bucket module - called once
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.0.0"

  bucket = "demo-app-bucket-${random_id.bucket_suffix.hex}"

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

  name                   = "web-server"
  instance_type          = "t2.micro"
  ami                    = "ami-07860a2d7eb515d9a"
  vpc_security_group_ids = [module.sg_web.security_group_id]

  tags = {
    Role = "web"
  }
}

module "ec2_app" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  name                   = "app-server"
  instance_type          = "t2.micro"
  ami                    = "ami-07860a2d7eb515d9a"
  vpc_security_group_ids = [module.sg_app.security_group_id]

  tags = {
    Role = "app"
  }
}

module "ec2_db" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  name                   = "db-server"
  instance_type          = "t2.small"
  ami                    = "ami-07860a2d7eb515d9a"
  vpc_security_group_ids = [module.sg_db.security_group_id]

  tags = {
    Role = "database"
  }
}

# Security group module - called 3 times (3 invocations)
module "sg_web" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "web-sg"
  description = "Security group for web servers"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  egress_rules        = ["all-all"]
}

module "sg_app" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "app-sg"
  description = "Security group for app servers"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["10.0.1.0/24"]
  ingress_rules       = ["http-8080-tcp"]
  egress_rules        = ["all-all"]
}

module "sg_db" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "db-sg"
  description = "Security group for database"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["10.0.2.0/24"]
  ingress_rules       = ["mysql-tcp"]
  egress_rules        = ["all-all"]
}