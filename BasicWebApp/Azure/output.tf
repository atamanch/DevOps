# Output the IP address of the load balanced scale set

output "scale_set_public_ip" {
  value = azurerm_public_ip.PubIP-Prod-StreamLitApp-Main-Public-1.ip_address
}