##################################################
# SecureTheCloud — Azure Zero Trust Network Module
##################################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_network_security_group" "zero_trust" {
  name                = "azure-zero-trust-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  ####################################################
  # Zero inbound (block all traffic)
  ####################################################
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  ####################################################
  # Outbound only to AzureCloud (Azure APIs)
  ####################################################
  security_rule {
    name                       = "AllowAzureAPIs"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  }
}
