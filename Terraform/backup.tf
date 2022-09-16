resource "azurerm_service_plan" "winserviceplan" {
  name                = "example"
  resource_group_name = "build-agents-terraform"
  location            = "westeurope"
  sku_name            = "S1"
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "winwebapp" {
  name                = "capgemwinwebapp"
  resource_group_name = "build-agents-terraform"
  location            = "westeurope"
  service_plan_id     = azurerm_service_plan.winserviceplan.id

  site_config {
     application_stack {
      current_stack = "dotnet"
      dotnet_version = "v6.0"
     }
  }
  backup {
    name = "backup"
    schedule {
        frequency_interval = "12"
        frequency_unit = "Hour"
        retention_period_days = "7"
    }
    storage_account_url = "https://capgemstoraccount.blob.core.windows.net/logs?sp=r&st=2022-08-31T13:48:05Z&se=2022-09-05T21:48:05Z&spr=https&sv=2021-06-08&sr=c&sig=r9b1yVbSEmGzn4MxNyu1eh53jht6pn558XhZb%2BrevVM%3D"
    enabled = "true"
  }
}
