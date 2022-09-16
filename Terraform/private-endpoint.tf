
resource "azurerm_virtual_network" "vnet" {
  name                = "build-agents-vnet"
  location            = "westeurope"
  resource_group_name = "build-agents-terraform"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "webapp_subnet" {
  name                 = "webapp-subnet"
  resource_group_name  = "build-agents-terraform"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "appgateway_subnet" {
  name                 = "appgateway-subnet"
  resource_group_name  = "build-agents-terraform"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "linux-app-service-plan"
  location            = "westeurope"
  resource_group_name = "build-agents-terraform"
  kind = "linux"
  reserved = true
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "appservice" {
  name                = "linux-app-service"
  location            = "westeurope"
  resource_group_name = "build-agents-terraform"
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id

   app_settings = {

    "DOCKER_REGISTRY_SERVER_URL"                = "https://hub.docker.com/repository/docker/herbertmoore/static-website-01"
    "DOCKER_REGISTRY_SERVER_USERNAME"           = "herbertmoore"
  }

  site_config {
     linux_fx_version = "DOCKER|herbertmoore/static-website-01:hello_world"
  }
}

resource "azurerm_private_dns_zone" "dnsprivatezone" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = "build-agents-terraform"
}

resource "azurerm_private_dns_zone_virtual_network_link" "dnszonelink" {
  name = "dnszonelink"
  resource_group_name = "build-agents-terraform"
  private_dns_zone_name = azurerm_private_dns_zone.dnsprivatezone.name
  virtual_network_id = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_endpoint" "privateendpoint" {
  name                = "backwebappprivateendpoint"
  location            = "westeurope"
  resource_group_name = "build-agents-terraform"
  subnet_id           = azurerm_subnet.webapp_subnet.id

  private_dns_zone_group {
    name = "privatednszonegroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.dnsprivatezone.id]
  }

  private_service_connection {
    name = "privateendpointconnection"
    private_connection_resource_id = azurerm_app_service.appservice.id
    subresource_names = ["sites"]
    is_manual_connection = false
  }
}