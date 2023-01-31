output "vm_publicip" {
  value = azurerm_public_ip.pubip-jenkinssrv.ip_address
}

output "vm_hostname" {
  value = azurerm_public_ip.pubip-jenkinssrv.fqdn
}
