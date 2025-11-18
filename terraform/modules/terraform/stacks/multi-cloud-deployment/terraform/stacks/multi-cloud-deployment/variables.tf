###############################################
# SecureTheCloud — Deployment Variables
###############################################

variable "aws_region" {
  description = "AWS region for compute + networking"
  default     = "us-east-1"
}

variable "aws_instance_profile" {
  description = "SSM-enabled instance profile name for EC2"
}

variable "azure_location" {
  description = "Azure region"
  default     = "eastus"
}

variable "azure_ssh_public_key" {
  description = "SSH key for Azure VM"
}

variable "gcp_project" {
  description = "GCP Project ID"
}

variable "gcp_region" {
  description = "GCP region for networking"
  default     = "us-central1"
}

variable "gcp_zone" {
  description = "GCP zone for compute"
  default     = "us-central1-a"
}

variable "gcp_service_account" {
  description = "GCP service account email for GCE VM"
}
