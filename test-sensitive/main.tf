resource "kubectl_manifest" "demo" {
  yaml_body = file("./manifest-v2.yaml")
}