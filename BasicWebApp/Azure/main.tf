# To use, please define variables.tf to match your expectations

provider "azurerm" {
    features{}
}

# Resource Group 
resource "azurerm_resource_group" "RG-Prod-StreamLitApp" {
    name = "Prod-StreamLitAppTF"
    location = var.location
    tags = var.tags
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
       public_key = file(var.ssh_public_key)
       username = "azureuser"
    }

    # Network Interface Definition
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

    # Image (OS) Definition
    source_image_reference {
        publisher = "OpenLogic"
        offer     = "CentOS"
        sku       = "8_2"
        version   = "latest"
    }

    # Reference to external shell script used for bootstrapping
    custom_data = base64encode(file("./setupScript.sh"))
}