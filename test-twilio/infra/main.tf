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

# Managed resource: mode = "managed", local name "demo".
resource "aws_instance" "demo" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "mode-collision-demo"
  }
}

# Data source reading back the exact same physical instance under the
# identical local name "demo". Terraform allows this because resources and
# data sources live in separate namespaces (distinguished only by "mode").
# generateResourceID (internal/adapters/postgres/resources.go) hashes
# provider+type+name+module+account+workspaceID+bindingID+pathID but omits
# mode, so aws_instance.demo and data.aws_instance.demo collide on the same
# generated UUID when both land in one UpsertResources batch.
data "aws_instance" "demo" {
  instance_id = aws_instance.demo.id

  depends_on = [aws_instance.demo]
}

output "resource_instance_id" {
  value = aws_instance.demo.id
}

output "data_instance_id" {
  value = data.aws_instance.demo.id
}
