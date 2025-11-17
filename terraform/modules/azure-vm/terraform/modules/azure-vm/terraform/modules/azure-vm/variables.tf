variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "vm_size" { default = "Standard_B1ms" }
variable "nic_id" {}
variable "ssh_public_key" {}
