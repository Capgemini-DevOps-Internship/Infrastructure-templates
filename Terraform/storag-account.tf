resource "azurerm_storage_account" "storageaccount" {
  name                     = "capgemstoraccount"
  resource_group_name      = "build-agents-terraform"
  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "blobcontainer" {
  name                  = "logs"
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "blob"
}