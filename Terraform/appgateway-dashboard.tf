data "azurerm_subscription" "current3" {}

resource "azurerm_dashboard" "my-board-3" {
  name                = "appGateway-dashboard"
  resource_group_name = "build-agents-templates"
  location            = "westeurope"
  tags = {
    source = "terraform"
  }
  dashboard_properties = templatefile("appGateway-dashboard.json",
    {
      sub_id     = data.azurerm_subscription.current3.subscription_id
  })
}