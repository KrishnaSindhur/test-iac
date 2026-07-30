terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubectl" {}

resource "kubectl_manifest" "demo" {
  yaml_body = sensitive(file(var.manifest_file))
}
