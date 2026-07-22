resource "kubectl_manifest" "demo" {
  # sensitive() marks yaml_body as sensitive in plan/state output (Harness sensitive-count testing)
  yaml_body = sensitive(file(var.manifest_file))
}
