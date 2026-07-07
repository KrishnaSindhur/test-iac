# Common variables used when running terraform/tofu at the TG root level.
# Modules define their own variables independently.

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

variable "instance_type" {
  description = "EC2 instance type (only used by EC2 modules)"
  type        = string
  default     = "t2.micro"
}

variable "bucket_name" {
  description = "S3 bucket name (only used by S3 modules)"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
