data "azurerm_subscription" "current" {}

resource "azurerm_dashboard" "my-board" {
  name                = "appService-dashboard"
  resource_group_name = "build-agents-templates"
  location            = "westeurope"
  tags = {
    source = "terraform"
  }
  dashboard_properties = templatefile("appService-dashboard.json",
    {
      sub_id     = data.azurerm_subscription.current.subscription_id
  })
}