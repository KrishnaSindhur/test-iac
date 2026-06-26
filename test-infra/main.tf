terraform {
  required_version = ">= 1.6.0"
}

# (1) Large VALID plan diff that renders BEFORE the failure.
#     OpenTofu's range() rejects more than 1024 values, so 1024 is the max
#     we can generate in a single call. 1024 instances * ~7 rendered lines
#     each => ~7k lines of plan output (comfortably above a 4k cap).
resource "terraform_data" "noise" {
  for_each = { for i in range(1024) : tostring(i) => i }

  input = join(",", [for n in range(20) : "field-${n}-value-${each.key}"])
}

# (2) Force a plan-time failure that prints AFTER the big diff above.
#     range() errors on more than 1024 values, so this always fails at plan.
#     OpenTofu still renders the successful resources first, then this error
#     ("planned the following actions, but then encountered a problem").
resource "terraform_data" "boom" {
  for_each = toset([for i in range(2000) : tostring(i)])

  input = each.key
}
