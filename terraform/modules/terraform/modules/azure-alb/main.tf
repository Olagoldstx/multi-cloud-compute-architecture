##################################################
# SecureTheCloud — Azure Load Balancer (Public)
##################################################

resource "azurerm_public_ip" "lb_public_ip" {
  name                = "${var.name}-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "lb" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicFrontEnd"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name                = "${var.name}-backend-pool"
  loadbalancer_id     = azurerm_lb.lb.id
  resource_group_name = var.resource_group_name
}

resource "azurerm_lb_probe" "health_probe" {
  name                = "${var.name}-probe"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Tcp"
  port                = 80
}

resource "azurerm_lb_rule" "lb_rule" {
  name                           = "${var.name}-lb-rule"
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicFrontEnd"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.health_probe.id
}
