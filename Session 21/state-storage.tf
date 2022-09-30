provider "azurerm" {
  features {}
}


resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate"
  resource_group_name      = "session21"
  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstatecont" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}