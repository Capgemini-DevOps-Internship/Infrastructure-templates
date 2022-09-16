data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                        = "CapgemKeyVault"
  location                    = "West Europe"
  resource_group_name         = "build-agents-terraform"
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "list"
    ]

    secret_permissions = [
      "Get", "list", "Set"
    ]
  }
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "secret"
  value        = "mysecretvalue"
  key_vault_id = azurerm_key_vault.keyvault.id
}