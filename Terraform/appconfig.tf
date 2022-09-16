resource "azurerm_app_configuration" "appconf" {
  name                = "appConf1"
  resource_group_name = "build-agents-terraform"
  location            = "westeurope"
  sku = "standard"
  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                        = "CapgemKeyVault-tf"
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
      "Get", 
      "List"
    ]

    secret_permissions = [
      "Get", 
      "List",
      "Set"
    ]
  }
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "secret"
  value        = "mysecretvalue"
  key_vault_id = azurerm_key_vault.keyvault.id
}

resource "azurerm_role_assignment" "appconf_datareader" {
  scope                = azurerm_app_configuration.appconf.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_app_configuration_key" "test" {
  configuration_store_id = azurerm_app_configuration.appconf.id
  key                    = "key1"
  type                   = "vault"
  label                  = "label1"
  vault_key_reference    = azurerm_key_vault_secret.secret.versionless_id

  depends_on = [
    azurerm_role_assignment.appconf_datareader
  ]
}