resource "azurerm_lb_nat_rule" "winrmdb_nat" {
  location = "${var.azure_region_fullname}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  loadbalancer_id = "${azurerm_lb.load_balancer.id}"
  name = "WinRM-db"
  protocol = "Tcp"
  frontend_port = "${count.index + 10000}"
  backend_port = "${var.vm_winrm_port}"
  frontend_ip_configuration_name = "${var.vm_name_prefix}-ipconfig"
}


resource "azurerm_network_interface" "dbnic" {
  name                = "dbnic"
  location            = "${var.azure_region_fullname}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  network_security_group_id = "${azurerm_network_security_group.dbvm_security_group.id}"

  ip_configuration {
    name = "dbserver-ipConfig"
    subnet_id = "${azurerm_subnet.subnet1.id}"
    private_ip_address_allocation = "dynamic"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.backend_pool.id}"]
    load_balancer_inbound_nat_rules_ids = ["${azurerm_lb_nat_rule.winrmdb_nat.id}"]
  }
}

resource "azurerm_virtual_machine" "dbvm" {
  name = "dbvm"
  location = "${var.azure_region_fullname}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  vm_size = "${var.db_vm_size}"
  network_interface_ids = ["${azurerm_network_interface.dbnic.id}"]
  availability_set_id = "${azurerm_availability_set.availability_set.id}"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2016-Datacenter"
    version = "latest"
  }

  storage_os_disk {
    name = "dbosdisk"
    caching       = "ReadWrite"
    create_option = "FromImage"
    vhd_uri = "${azurerm_storage_account.storage_account.primary_blob_endpoint}${azurerm_storage_container.container.name}/dbosdisk.vhd"
  }

  os_profile {
    computer_name = "dbvm"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
    #Include Deploy.PS1 with variables injected as custom_data
    custom_data = "${base64encode("Param($RemoteHostName = \"dbvm.${var.azure_region}.${var.azure_dns_suffix}\", $ComputerName = \"dbvm\", $WinRmPort = ${var.vm_winrm_port}) ${file("Deploy.PS1")}")}"
  }

  tags {
    environment = "${var.environment_tag}"
  }

  os_profile_windows_config {
    provision_vm_agent = true
    enable_automatic_upgrades = true

    additional_unattend_config {
      pass = "oobeSystem"
      component = "Microsoft-Windows-Shell-Setup"
      setting_name = "AutoLogon"
      content = "<AutoLogon><Password><Value>${var.admin_password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.admin_username}</Username></AutoLogon>"
    }
    #Unattend config is to enable basic auth in WinRM, required for the provisioner stage.
    additional_unattend_config {
      pass = "oobeSystem"
      component = "Microsoft-Windows-Shell-Setup"
      setting_name = "FirstLogonCommands"
      content = "${file("FirstLogonCommands.xml")}"
    }
  }

  provisioner "file" {
    source = "DBserverDsc.PS1"
        destination = "C:\\Scripts\\DBserverDsc.PS1"
        connection {
            type = "winrm"
            https = true
            insecure = true
            user = "${var.admin_username}"
            password = "${var.admin_password}"
            host = "${azurerm_resource_group.resource_group.name}.${var.azure_region}.${var.azure_dns_suffix}"
            port = "10000"
        }
    }

  provisioner "remote-exec" {
    inline = [
      "powershell.exe -sta -ExecutionPolicy Unrestricted -file C:\\Scripts\\DBserverDsc.ps1",
    ]
    connection {
      type = "winrm"
      timeout = "20m"
      https = true
      insecure = true
      user = "${var.admin_username}"
      password = "${var.admin_password}"
      host = "${azurerm_resource_group.resource_group.name}.${var.azure_region}.${var.azure_dns_suffix}"
      port = "10000"
    }
  }
}
