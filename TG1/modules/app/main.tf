variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "instance_count" {
  type    = number
  default = 2
}

variable "instance_type" {
  type    = string
  default = "t2.small"
}

variable "project" {
  type    = string
  default = "test-iac-tg1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.30.0.0/16"

  tags = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.30.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project}-subnet"
  }
}

resource "aws_instance" "main" {
  count         = var.instance_count
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id

  tags = {
    Name    = "${var.project}-instance-${count.index + 1}"
    Project = var.project
  }

  # A newer Amazon Linux AMI (most_recent = true) would otherwise force-replace
  # the instances on every apply. Ignore post-create AMI changes so existing
  # instances are kept and re-applies are idempotent (no destroy/create churn).
  lifecycle {
    ignore_changes = [ami]
  }
}

output "instance_ids" {
  value = aws_instance.main[*].id
}

output "instance_private_ips" {
  value = aws_instance.main[*].private_ip
}
