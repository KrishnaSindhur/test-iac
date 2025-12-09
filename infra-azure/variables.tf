variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "vm_size" {
  description = "Azure VM size (B1s is free-tier eligible)"
  type        = string
  default     = "Standard_B1s"
}
