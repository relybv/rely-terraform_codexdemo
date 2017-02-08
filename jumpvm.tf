resource "azurerm_public_ip" "jumpserver_public_ip" {
  name                         = "jumpserver-ip"
  location                     = "${var.azure_region_fullname}"
  resource_group_name          = "${azurerm_resource_group.resource_group.name}"
  public_ip_address_allocation = "dynamic"
  domain_name_label = "jumpserver-${azurerm_resource_group.resource_group.name}"
}


resource "azurerm_network_interface" "jumpnic" {
  name                = "jumpnic"
  location            = "${var.azure_region_fullname}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  network_security_group_id = "${azurerm_network_security_group.jumpvm_security_group.id}"

  ip_configuration {
    name = "jumpserver-ipConfig"
    subnet_id = "${azurerm_subnet.subnet1.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${azurerm_public_ip.jumpserver_public_ip.id}"
  }
}

resource "azurerm_virtual_machine" "jumpvm" {
  name = "jumpvm"
  location = "${var.azure_region_fullname}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  vm_size = "${var.jump_vm_size}"
  network_interface_ids = ["${azurerm_network_interface.jumpnic.id}"]

  os_profile {
    computer_name = "jumpvm"
    admin_username = "ubuntu"
    admin_password = "Passwword1234"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/ubuntu/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/id_rsa.terraform.pub")}"
    }
  }

  storage_os_disk {
    name = "jumposdisk"
    caching       = "ReadWrite"
    create_option = "FromImage"
    vhd_uri = "${azurerm_storage_account.storage_account.primary_blob_endpoint}${azurerm_storage_container.container.name}/jumposdisk.vhd"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "14.04.2-LTS"
    version   = "latest"
  }
}
