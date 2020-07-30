# Virtual Network

resource "azurerm_virtual_network" "vNet-Prod-StreamLitApp" {
    name = "vNet-Main"
    address_space = ["10.0.0.0/16"]
    resource_group_name = azurerm_resource_group.RG-Prod-StreamLitApp.name
    location = azurerm_resource_group.RG-Prod-StreamLitApp.location
    tags = var.tags
}

# Subnet
resource "azurerm_subnet" "Subnet-Prod-StreamLitApp-Main-Public-1" {
    name = "vNet-Main-Public-1"  
    resource_group_name = azurerm_resource_group.RG-Prod-StreamLitApp.name
    virtual_network_name = azurerm_virtual_network.vNet-Prod-StreamLitApp.name
    address_prefixes = ["10.0.1.0/24"]
}