variable "azure_location" {
  description = "Azure location where the VM will be created"
  type        = string
  default     = "eastus"
}

variable "vm_size" {
  description = "Azure VM size (similar to EC2 instance type)"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for the VM (demo only — change this and mark as sensitive in real setups)"
  type        = string
  default     = "ChangeMe1234!"
}
