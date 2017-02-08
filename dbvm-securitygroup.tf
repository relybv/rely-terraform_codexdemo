
resource "azurerm_network_security_group" "dbvm_security_group" {
    name = "dbvm-sg"
    location = "${var.azure_region_fullname}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"

    tags {
        environment = "${var.environment_tag}"
    }
}

resource "azurerm_network_security_rule" "dbrdpRule" {
    name = "dbrdpRule"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "3389"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    network_security_group_name = "${azurerm_network_security_group.dbvm_security_group.name}"
}

resource "azurerm_network_security_rule" "dbwinrmRule" {
    name = "dbwinrmRule"
    priority = 110
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "${var.vm_winrm_port}"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    network_security_group_name = "${azurerm_network_security_group.dbvm_security_group.name}"
}

resource "azurerm_network_security_rule" "dbRule" {
    name = "dbRule"
    priority = 120
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "1433"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    network_security_group_name = "${azurerm_network_security_group.dbvm_security_group.name}"
}

