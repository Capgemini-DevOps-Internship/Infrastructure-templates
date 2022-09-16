
provider "azurerm" {
    features {}
}
 
resource "azurerm_storage_account" "storage_account" {
  name                = "capgemstaticwebsite"
  resource_group_name = "build-agents-terraform"
  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
 
  static_website {
    index_document = "index.html"
    error_404_document = "error.html"
  }
}
 

resource "azurerm_storage_blob" "blob_container" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = "static-website"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = "<h1>example static website from Terraform</h1>"
}