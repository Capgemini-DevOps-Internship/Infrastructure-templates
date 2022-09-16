
resource "azurerm_virtual_network" "vnet2" {
  name                = "build-agents-vnet-2"
  address_space       = ["10.0.0.0/16"]
  location            = "westeurope"
  resource_group_name = "build-agents-terraform"
}

resource "azurerm_subnet" "subnet" {
  name                 = "endpointsubnet"
  resource_group_name  = "build-agents-terraform"
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "webapp-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_app_service_plan" "appserviceplan2" {
  name                = "linux-app-service-plan-2"
  location            = "westeurope"
  resource_group_name = "build-agents-terraform"
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "appservice2" {
  name                = "linux-app-service-2"
  location            = "westeurope"
  resource_group_name = "build-agents-terraform"
  app_service_plan_id = azurerm_app_service_plan.appserviceplan2.id

   app_settings = {

    "DOCKER_REGISTRY_SERVER_URL"                = "https://hub.docker.com/repository/docker/herbertmoore/static-website-01"
    "DOCKER_REGISTRY_SERVER_USERNAME"           = "herbertmoore"
  }

  site_config {
     linux_fx_version = "DOCKER|herbertmoore/static-website-01:hello_world"
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "example" {
  app_service_id = azurerm_app_service.appservice2.id
  subnet_id      = azurerm_subnet.subnet.id
}