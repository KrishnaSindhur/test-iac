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

# VPC and Networking
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "demo-vpc"
  }
}

resource "aws_subnet" "web" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "web-subnet"
  }
}

resource "aws_subnet" "app" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "app-subnet"
  }
}

resource "aws_subnet" "db" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "db-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "demo-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "web" {
  subnet_id      = aws_subnet.web.id
  route_table_id = aws_route_table.public.id
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
  subnet_id              = aws_subnet.web.id
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
  subnet_id              = aws_subnet.app.id
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
  subnet_id              = aws_subnet.db.id
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
  vpc_id      = aws_vpc.main.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  egress_rules        = ["all-all"]
}

module "sg_app" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "app-sg"
  description = "Security group for app servers"
  vpc_id      = aws_vpc.main.id

  ingress_cidr_blocks = ["10.0.1.0/24"]
  ingress_rules       = ["http-8080-tcp"]
  egress_rules        = ["all-all"]
}

module "sg_db" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "db-sg"
  description = "Security group for database"
  vpc_id      = aws_vpc.main.id

  ingress_cidr_blocks = ["10.0.2.0/24"]
  ingress_rules       = ["mysql-tcp"]
  egress_rules        = ["all-all"]
}