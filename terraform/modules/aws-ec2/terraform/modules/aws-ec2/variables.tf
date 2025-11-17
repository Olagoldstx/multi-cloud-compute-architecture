variable "name" {}
variable "instance_type" { default = "t3.micro" }
variable "subnet_id" {}
variable "security_group_id" {}
variable "kms_key_id" {}
variable "instance_profile" {}
