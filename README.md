# Terraform-AzureRM-Example

Quick Instruction:

Download and install Terraform
https://www.terraform.io/downloads.html

Create credentials using the "clasic portal" procedure on https://www.terraform.io/docs/providers/azurerm/

Edit the TerraformCredentials.ps1 and enter API keys

Load Powershell

"dot source" the credentials to load them into environment variables

      . .\TerraformCredentials.ps1

Test the configuration

      terraform plan

Build the resources

      terraform apply

Delete the resources

      terraform destroy

