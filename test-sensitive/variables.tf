terraform {
  required_version = ">= 0.13"
}

variable "manifest_file" {
  description = "Manifest YAML path — use ./manifest-v1.yaml then ./manifest-v2.yaml"
  type        = string
  default     = "./manifest-v1.yaml"
}
