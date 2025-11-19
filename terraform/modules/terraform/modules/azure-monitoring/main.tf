##################################################
# SecureTheCloud — Azure Monitoring & Security
##################################################

###############################################
# 1. Log Analytics Workspace (central logging)
###############################################

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

###############################################
# 2. Enable NSG Flow Logs (via Network Watcher)
###############################################

resource "azurerm_network_watcher" "nw" {
  name                = "${var.prefix}-nw"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_watcher_flow_log" "flow_logs" {
  network_watcher_name = azurerm_network_watcher.nw.name
  resource_group_name  = var.resource_group_name
  network_security_group_id = var.nsg_id
  storage_account_id   = var.storage_account_id

  traffic_analytics {
    enabled               = true
    workspace_id          = azurerm_log_analytics_workspace.law.workspace_id
    workspace_region      = var.location
    workspace_resource_id = azurerm_log_analytics_workspace.law.id
  }
}

###############################################
# 3. Diagnostic Settings for LB + NIC + VM
###############################################

resource "azurerm_monitor_diagnostic_setting" "diag_lb" {
  name               = "${var.prefix}-lb-diag"
  target_resource_id = var.lb_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }

  log {
    category = "LoadBalancerProbeHealthStatus"
    enabled  = true
  }
}

###############################################
# 4. Defender for Cloud (Security Center)
###############################################

resource "azurerm_security_center_contact" "contact" {
  phone = "0000000000"
  email = "admin@securethecloud.dev"
}

resource "azurerm_security_center_subscription_pricing" "standard" {
  tier = "Standard"
}
