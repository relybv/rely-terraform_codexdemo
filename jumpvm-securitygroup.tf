resource "azurerm_network_security_group" "jumpvm_security_group" {
    name = "jumpvm_security_group"
    location = "${var.azure_region_fullname}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"

    tags {
        environment = "${var.environment_tag}"
    }
}

resource "azurerm_network_security_rule" "sshRule" {
    name = "sshRule"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    network_security_group_name = "${azurerm_network_security_group.jumpvm_security_group.name}"
}
