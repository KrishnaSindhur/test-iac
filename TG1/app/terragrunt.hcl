# Single stack under TG1. Harness IaCM collects the plan file per subdirectory
# stack, so the module lives here (not at the TG1 root).
# No remote_state block — Harness IaCM manages state. Provider is in main.tf.
