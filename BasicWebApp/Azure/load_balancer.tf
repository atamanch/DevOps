# Load-Balancer for scale set

resource "azurerm_lb" "LB-Prod-StreamLitApp-Main-Public-1" {
  name                = "Pub-Prod-LB-StreamLitApp"
  location            = azurerm_resource_group.RG-Prod-StreamLitApp.location
  resource_group_name = azurerm_resource_group.RG-Prod-StreamLitApp.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.PubIP-Prod-StreamLitApp-Main-Public-1.id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "BE-Addr-Pool" {
  resource_group_name = azurerm_resource_group.RG-Prod-StreamLitApp.name
  loadbalancer_id     = azurerm_lb.LB-Prod-StreamLitApp-Main-Public-1.id
  name                = "BackEndAddressPool"
}

# Load Balancer Health Check (Probe)
resource "azurerm_lb_probe" "LB-Probe-Prod-StreamLitApp-Main-Public-1" {
  resource_group_name = azurerm_resource_group.RG-Prod-StreamLitApp.name
  loadbalancer_id     = azurerm_lb.LB-Prod-StreamLitApp-Main-Public-1.id
  name                = "Probe-Port-80"
  protocol            = "Http"
  port                = 80
  request_path        = "/"
}

resource "azurerm_lb_rule" "lbrule" {
  resource_group_name            = azurerm_resource_group.RG-Prod-StreamLitApp.name
  loadbalancer_id                = azurerm_lb.LB-Prod-StreamLitApp-Main-Public-1.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  backend_address_pool_id        = azurerm_lb_backend_address_pool.BE-Addr-Pool.id
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.LB-Probe-Prod-StreamLitApp-Main-Public-1.id
}

# Public IP for Load Balancer
resource "azurerm_public_ip"  "PubIP-Prod-StreamLitApp-Main-Public-1"  {
    name = "Pub-Prod-LB-IP-StreamLitApp"
    location = azurerm_resource_group.RG-Prod-StreamLitApp.location
    resource_group_name = azurerm_resource_group.RG-Prod-StreamLitApp.name
    allocation_method = "Static"
    sku = "Standard"
}
