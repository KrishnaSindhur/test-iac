# Single-stack Terragrunt for Harness IaCM.
# Workspace folder path: TG1 (not TG1/app).
# Harness collects plan files from the workspace root only — use tfplan (same as TG).

terraform {
  extra_arguments "plan_file" {
    commands  = ["plan"]
    arguments = ["-out=tfplan"]
  }
}
