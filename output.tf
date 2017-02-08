output "LB fqdn" {
    value = "${azurerm_public_ip.load_balancer_public_ip.fqdn}"
}

output "LB public IP" {
    value = "${azurerm_public_ip.load_balancer_public_ip.ip_address}"
}

output "Jump server fqdn" {
    value = "${azurerm_public_ip.jumpserver_public_ip.fqdn}"
}

output "Jump server public IP" {
    value = "${azurerm_public_ip.jumpserver_public_ip.ip_address}"
}


output "RDP servers" {
    value = "${join(", ", azurerm_network_interface.vm_nic.*.private_ip_address)}"
}

output "DB server" {
  value = "${azurerm_network_interface.dbnic.private_ip_address}"
}
