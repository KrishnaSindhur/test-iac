terraform {
  required_version = ">= 1.6.0"
}

# (1) Generate a massive plan diff — tune the count to exceed your 5k-line cap.
resource "terraform_data" "noise" {
  for_each = { for i in range(3000) : tostring(i) => i }

  input = join(",", [for n in range(20) : "field-${n}-value-${each.key}"])
}

# (2) Defer the type error to graph-walk time so it prints AFTER the diff.
variable "raw_sheets" {
  type = any
  default = [
    { sheet_id = "s1", name = "Overview" },
    { sheet_id = "s2" },                                 # different object shape
    { sheet_id = "s3", name = "Extra", color = "blue" },
  ]
}

resource "terraform_data" "dashboard" {
  # tolist() over a tuple of differently-shaped objects raises
  # "all list elements must have the same type" during plan evaluation.
  input = tolist(var.raw_sheets)
}