variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "default-owner"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "simple-tg"
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Instance type (unused in S3; allows CLI/tfvars override compatibility)"
  type        = string
  default     = "t2.micro"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "access_key" {
  description = "Access Key (sensitive)"
  type        = string
  default     = "AKIAIOSFODNN7EXAMPLE"
  sensitive   = true
}

locals {
  bucket_name = var.bucket_name != "" ? var.bucket_name : "${var.project}-${var.environment}-bucket"

  common_tags = {
    Owner       = var.owner
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terragrunt"
  }
}

resource "aws_s3_bucket" "main" {
  bucket = local.bucket_name
  tags   = local.common_tags
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.main.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.main.arn
}

output "bucket_tags" {
  description = "Tags applied to the S3 bucket"
  value       = aws_s3_bucket.main.tags
}

output "access_key" {
  description = "Access Key (sensitive)"
  value       = var.access_key
  sensitive   = true
}
