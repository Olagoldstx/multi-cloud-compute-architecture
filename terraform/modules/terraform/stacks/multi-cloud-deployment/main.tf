###############################################
# SecureTheCloud — Multi-Cloud Deployment Stack
###############################################

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

###############################################
# AWS PROVIDER
###############################################

provider "aws" {
  region = var.aws_region
}

###############################################
# AZURE PROVIDER
###############################################

provider "azurerm" {
  features {}
}

###############################################
# GCP PROVIDER
###############################################

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
  zone    = var.gcp_zone
}

###############################################
# AWS NETWORK (VPC + Private Subnet)
###############################################

resource "aws_vpc" "main" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "stc-aws-vpc" }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false
  tags = { Name = "stc-aws-private-subnet" }
}

resource "aws_security_group" "ec2_sg" {
  name   = "stc-aws-ec2-sg"
  vpc_id = aws_vpc.main.id

  # Zero trust: no inbound
  ingress {}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "stc-ec2-sg" }
}

resource "aws_kms_key" "ec2" {
  description = "SecureTheCloud EC2 Encryption Key"
}

###############################################
# AWS ZERO TRUST NETWORK MODULE
###############################################

module "aws_zero_trust" {
  source          = "../../modules/aws-network"
  vpc_id          = aws_vpc.main.id
  private_subnets = [aws_subnet.private.id]
  region          = var.aws_region
}

###############################################
# AWS EC2 MODULE
###############################################

module "aws_ec2" {
  source = "../../modules/aws-ec2"
 name              = "aws-secure-vm"
  instance_type     = "t3.micro"
  subnet_id         = aws_subnet.private.id

  # Zero Trust Security Group (replaces older SG)
  security_group_id = module.aws_zero_trust.zero_trust_sg_id

  kms_key_id        = aws_kms_key.ec2.arn
  instance_profile  = var.aws_instance_profile
}

###############################################
# AWS APPLICATION LOAD BALANCER
###############################################

module "aws_alb" {
  source = "../../modules/aws-alb"

  name           = "aws-secure-alb"
  vpc_id         = aws_vpc.main.id
  sg_id          = module.aws_zero_trust.zero_trust_sg_id

  # For now, LB will be internal only, using your existing subnet
  public_subnets = [aws_subnet.private.id]
}

###############################################
# AWS MONITORING & SECURITY MODULE
###############################################

module "aws_monitoring" {
  source = "../../modules/aws-monitoring"

  prefix                = "stc"
  region                = var.aws_region
  vpc_id                = aws_vpc.main.id

  # Logging buckets you will create in next step
  cloudtrail_bucket     = "stc-cloudtrail-${var.aws_region}"
  flow_logs_bucket_arn  = "arn:aws:s3:::stc-flowlogs-${var.aws_region}"

  # Pass ALB ARN for enabling access logs
  alb_arn               = module.aws_alb.alb_arn
}


 

###############################################
# AZURE NETWORK (RG + VNet + Subnet + NSG)
###############################################

resource "azurerm_resource_group" "rg" {
  name     = "stc-azure-rg"
  location = var.azure_location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "stc-azure-vnet"
  address_space       = ["10.20.0.0/16"]
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "stc-azure-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "stc-azure-nsg"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.rg.name
}

###############################################
# AZURE ZERO TRUST NETWORK MODULE
###############################################

module "azure_zero_trust" {
  source              = "../../modules/azure-network"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.rg.name
}

###############################################
# AZURE ZERO TRUST NETWORK MODULE
###############################################

module "azure_zero_trust" {
  source              = "../../modules/azure-network"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_interface" "nic" {
  name                = "stc-azure-nic"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.rg.name

  # ATTACH ZERO-TRUST NSG HERE (INSIDE BLOCK)
  network_security_group_id = module.azure_zero_trust.nsg_id

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

###############################################
# AZURE VM MODULE
###############################################

module "azure_vm" {
  source              = "../../modules/azure-vm"

###############################################
# AZURE LOAD BALANCER
###############################################

module "azure_alb" {
  source              = "../../modules/azure-alb"
  name                = "azure-secure-lb"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.rg.name
  nic_id              = azurerm_network_interface.nic.id
}

###############################################
# STORAGE ACCOUNT FOR NSG FLOW LOGS
###############################################

resource "random_integer" "unique_id" {
  min = 10000
  max = 99999
}

resource "azurerm_storage_account" "stc_monitoring" {
  name                     = "stcmonitor${random_integer.unique_id.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.azure_location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "monitoring"
  }
}

###############################################
# AZURE MONITORING & SECURITY MODULE
###############################################

module "azure_monitoring" {
  source = "../../modules/azure-monitoring"

  prefix              = "stc"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.rg.name

  # Zero Trust NSG (already created in Stage 2)
  nsg_id              = module.azure_zero_trust.nsg_id

  # Azure requires a storage account ID for NSG Flow Logs
  storage_account_id  = azurerm_storage_account.stc_monitoring.id

  # Load Balancer diagnostics
  lb_id               = module.azure_alb.lb_id
}

###############################################
# GCP NETWORK (VPC + Subnetwork + Firewall)
###############################################

resource "google_compute_network" "vpc" {
  name                    = "stc-gcp-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "stc-gcp-subnet"
  region        = var.gcp_region
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.30.1.0/24"
}

resource "google_compute_firewall" "allow_internal" {
  name    = "stc-gcp-allow-internal"
  network = google_compute_network.vpc.name

  allows {
    protocol = "all"
  }

  source_ranges = ["10.30.0.0/16"]
}

###############################################
# GCP ZERO TRUST NETWORK MODULE
###############################################

module "gcp_zero_trust" {
  source  = "../../modules/gcp-network"
  network = google_compute_network.vpc.name
}


###############################################
# GCP VM MODULE
###############################################

module "gcp_vm" {
  source = "../../modules/gcp-compute"

  name                  = "gcp-secure-vm"
  machine_type          = "e2-micro"
  zone                  = var.gcp_zone
  network               = google_compute_network.vpc.id
  subnetwork            = google_compute_subnetwork.subnet.id
  service_account_email = var.gcp_service_account
}

###############################################
# GCP GLOBAL HTTPS LOAD BALANCER
###############################################

module "gcp_lb" {
  source        = "../../modules/gcp-lb"
  name          = "gcp-secure-lb"
  project       = var.gcp_project
  region        = var.gcp_region

  # We can integrate an instance group later if needed
  instance_group = null
}

###############################################
# GCP LOGGING BUCKET (for Log Sink)
###############################################

resource "google_storage_bucket" "gcp_logs" {
  name     = "stc-gcplogs-${var.gcp_project}"
  location = var.gcp_region
}

###############################################
# GCP MONITORING & SECURITY MODULE
###############################################

module "gcp_monitoring" {
  source   = "../../modules/gcp-monitoring"
  prefix   = "stc"
  project  = var.gcp_project
  region   = var.gcp_region

  # Required for SCC & LB logs & VPC flow logs
  network      = google_compute_network.vpc.id

  # GCP log sink storage bucket (we will create this next)
  bucket_name  = "stc-gcplogs-${var.gcp_project}"
}
