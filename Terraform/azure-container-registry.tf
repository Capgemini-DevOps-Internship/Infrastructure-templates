resource "azurerm_container_registry" "acr" {
  name                = "capgemacr3"
  resource_group_name = "build-agents-terraform"
  location            = "westeurope"
  sku                 = "Standard"
  admin_enabled       = true
}