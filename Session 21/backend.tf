terraform {
    backend "azurerm" {
        resource_group_name  = "session21"
        storage_account_name = "capgemtfstate"
        container_name       = "capgemtfstate"
        key                  = "terraform.tfstate"
    }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "state-demo-secure" {
  name     = "state-demo"
  location = "eastus"
}