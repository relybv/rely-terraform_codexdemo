variable "azure_resource_group_name" {
    description = "Resource Group Name"
    default = "tfcodexgp4"
}

variable "vm_name_prefix" { 
    description = "The Virtual Machine Name"
    default = "tfcodexrds"
}

variable "vm_count" {
    description = "Number of RDS VMs to create"
    default = "2"
}

#Re-applying a new size reboots the VMs and re-runs the provisioner scripts - Use DSC Push to configure to avoid errors
variable "vm_size" { 
    description = "Azure VM Size"
    default = "Standard_A2_v2"
}

variable "db_vm_size" {
    description = "Azure VM Size"
    default = "Standard_A1_v2"
}

variable "jump_vm_size" {
    description = "Azure VM Size"
    default = "Standard_A1_v2"
}

variable "vm_winrm_port" {
    description = "WinRM Public Port"
    default = "5986"
}

variable "azure_region" {
    description = "Azure Region for all resources"
    default = "westeurope"
}

variable "azure_region_fullname" {
    description = "Long name for the Azure Region, ie. North Europe"
    default = "West Europe"
}

variable "azure_dns_suffix" {
    description = "Azure DNS suffix for the Public IP"
    default = "cloudapp.azure.com"
}

variable "admin_username" {
    description = "Username for the Administrator account"
    default = "TestAdmin"
}

# set password as 'export TF_VAR_admin_password=<password>'
variable "admin_password" {
    description = "Password for the Administrator account"
}

variable "environment_tag" {
    description = "Tag to apply to the resoucrces"
    default = "Terraform-Codex-Poc"
}

