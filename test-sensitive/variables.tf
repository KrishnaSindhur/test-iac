terraform {
  required_version = ">= 1.6.0"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
}

provider "kubectl" {
  # uses ~/.kube/config by default
}