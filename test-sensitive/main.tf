resource "kubectl_manifest" "demo" {
  yaml_body = file("./manifest-v1.yaml")
}