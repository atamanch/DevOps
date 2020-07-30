# Network Security Group

resource "azurerm_network_security_group" "inbound-web" {
  name                = "inbound-web"
  location            = azurerm_resource_group.RG-Prod-StreamLitApp.location
  resource_group_name = azurerm_resource_group.RG-Prod-StreamLitApp.name
}

resource "azurerm_network_security_rule" "ssh-22-ingress" {
  name                        = "ssh-22-ingress"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.RG-Prod-StreamLitApp.name
  network_security_group_name = azurerm_network_security_group.inbound-web.name
}

resource "azurerm_network_security_rule" "web-80-ingress" {
  name                        = "web-80-ingress"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.RG-Prod-StreamLitApp.name
  network_security_group_name = azurerm_network_security_group.inbound-web.name
}

resource "azurerm_network_security_rule" "web-80-egress" {
  name                        = "web-80-egress"
  priority                    = 101
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "80"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.RG-Prod-StreamLitApp.name
  network_security_group_name = azurerm_network_security_group.inbound-web.name
}

resource "azurerm_subnet_network_security_group_association" "web-subnet-assoc" {
  subnet_id                 = azurerm_subnet.Subnet-Prod-StreamLitApp-Main-Public-1.id
  network_security_group_id = azurerm_network_security_group.inbound-web.id
}