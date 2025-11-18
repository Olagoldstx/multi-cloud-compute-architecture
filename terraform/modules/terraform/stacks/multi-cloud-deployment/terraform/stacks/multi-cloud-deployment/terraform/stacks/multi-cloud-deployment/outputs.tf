###############################################
# SecureTheCloud — Deployment Outputs
###############################################

output "aws_private_ip" {
  value       = module.aws_ec2.private_ip
  description = "Private IP of AWS EC2 instance"
}

output "azure_private_ip" {
  value       = module.azure_vm.private_ip
  description = "Private IP of Azure VM"
}

output "gcp_internal_ip" {
  value       = module.gcp_vm.internal_ip
  description = "Internal IP of GCP Compute Engine instance"
}
