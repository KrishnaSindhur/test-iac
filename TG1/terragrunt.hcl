# Single-stack Terragrunt for Harness IaCM.
# Workspace folder path: TG1
#
# Harness IaCM + OpenTofu 1.11 saves plan.tfplan (ignores -out=tfplan).
# The plugin collects tfplan from the workspace root — copy after plan.

terraform {
  after_hook "harness_plan_file" {
    commands     = ["plan"]
    execute      = ["sh", "-c", "test -f plan.tfplan && cp -f plan.tfplan tfplan"]
    run_on_error = false
  }
}
