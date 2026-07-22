terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubectl" {
  # Requires a reachable cluster for apply. Plan can run with a valid kubeconfig.
}

variable "manifest_file" {
  description = "Manifest YAML path — use ./manifest-v1.yaml then ./manifest-v2.yaml"
  type        = string
  default     = "./manifest-v1.yaml"
}
