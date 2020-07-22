provider "azurerm" {
    features{}
}

# Resource Group 
resource "azurerm_resource_group" "RG-Prod-StreamLitApp" {
    name = "Prod-StreamLitAppTF"
    location = "EastUS"
    
    tags = {
    Environment = "Production"
    Group = "Finance"
    Criticality = "Critical"
    }
}

# Virtual Network
resource "azurerm_virtual_network" "vNet-Prod-StreamLitApp" {
    name = "vNet-Main"
    address_space = ["10.0.0.0/16"]
    resource_group_name = azurerm_resource_group.RG-Prod-StreamLitApp.name
    location = azurerm_resource_group.RG-Prod-StreamLitApp.location

    tags = {
    Environment = "Production"
    Group = "Finance"
    Criticality = "Critical"
    }
}

# Subnet
resource "azurerm_subnet" "Subnet-Prod-StreamLitApp-Main-Public-1" {
    name = "vNet-Main-Public-1"  
    resource_group_name = azurerm_resource_group.RG-Prod-StreamLitApp.name
    virtual_network_name = azurerm_virtual_network.vNet-Prod-StreamLitApp.name
    address_prefixes = ["10.0.1.0/24"]
}

# Virtual Machine Scale Set 
resource "azurerm_linux_virtual_machine_scale_set" "VMSS-Prod-StreamLitApp" {
    name = "VMSS-Prod-StreamLitApp"
    resource_group_name = azurerm_resource_group.RG-Prod-StreamLitApp.name
    location = azurerm_resource_group.RG-Prod-StreamLitApp.location
    zones = [1,2]

    sku = "Standard_B1s"
    instances = 2

    admin_username = "azureuser"
    disable_password_authentication = true

    admin_ssh_key {
       public_key = "<insert public ssh key here>"
       username = "azureuser"
    }

    network_interface {
        name = "Primary-NIC"
        primary = true

        ip_configuration {
            name = "VMSS-IPConfig"
            subnet_id = azurerm_subnet.Subnet-Prod-StreamLitApp-Main-Public-1.id
            primary = true
            load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.BE-Addr-Pool.id]
            public_ip_address {
                name = "VMSS-Public-IP"
            }
        }
    }

    os_disk {
        storage_account_type = "Standard_LRS"
        caching = "ReadWrite"
    }

    source_image_reference {
        publisher = "OpenLogic"
        offer     = "CentOS"
        sku       = "8_2"
        version   = "latest"
    }

    custom_data = base64encode(file("./setupScript.sh"))
}

# Public IP for Load Balancer
resource "azurerm_public_ip"  "PubIP-Prod-StreamLitApp-Main-Public-1"  {
    name = "Pub-Prod-LB-IP-StreamLitApp"
    location = azurerm_resource_group.RG-Prod-StreamLitApp.location
    resource_group_name = azurerm_resource_group.RG-Prod-StreamLitApp.name
    allocation_method = "Static"
    sku = "Standard"
}


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

    tags = {
    Environment = "Production"
    Group = "Finance"
    Criticality = "Critical"
    }
}

resource "azurerm_lb_backend_address_pool" "BE-Addr-Pool" {
  resource_group_name = azurerm_resource_group.RG-Prod-StreamLitApp.name
  loadbalancer_id     = azurerm_lb.LB-Prod-StreamLitApp-Main-Public-1.id
  name                = "BackEndAddressPool"
}

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