resource "azurerm_virtual_network" "vnet3" {
  name                = "build-agents-vnet-3"
  address_space       = ["10.0.0.0/16"]
  location            = "westeurope"
  resource_group_name = "build-agents-terraform"
}

resource "azurerm_subnet" "subnet" {
  name                 = "endpointsubnet"
  resource_group_name  = "build-agents-terraform"
  virtual_network_name = azurerm_virtual_network.vnet3.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "webapp-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
    }
  }

  service_endpoints = ["Microsoft.Sql"]
}

resource "azurerm_mssql_server" "sqlserver" {
    name                         = "capgemsqlserver"
    resource_group_name          = "build-agents-terraform"
    location                     = "westeurope"
    version                      = "12.0"
    administrator_login          = "4dm1n157r470r"
    administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_mssql_firewall_rule" "firewallrule" {
  name                = "AlllowSql Subnet"
  server_id         = "${azurerm_mssql_server.sqlserver.id}"
  start_ip_address    = "10.0.0.0"
  end_ip_address      = "10.0.0.255"
  depends_on =[
    azurerm_mssql_server.sqlserver
  ]
}

resource "azurerm_mssql_database" "sqldb" {
  name           = "capgemsqldb"
  server_id      = azurerm_mssql_server.sqlserver.id
  sku_name       = "S1"
  geo_backup_enabled = true
  depends_on =[
    azurerm_mssql_server.sqlserver
  ]
}

resource "azurerm_service_plan" "appserviceplan-3" {
  name                = "capgemlinuxwebapp"
  resource_group_name = "build-agents-terraform"
  location            = "westeurope"
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "linuxwebapp" {
  name                = "capgemlinuxwebapp"
  resource_group_name = "build-agents-terraform"
  location            = "westeurope"
  service_plan_id     = azurerm_service_plan.appserviceplan-3.id

  app_settings = {

    "DOCKER_REGISTRY_SERVER_URL"                = "https://hub.docker.com/repository/docker/herbertmoore/static-website-01"
    "DOCKER_REGISTRY_SERVER_USERNAME"           = "herbertmoore"
  }

  site_config {
     application_stack {
      docker_image     = "herbertmoore/static-website-01"
      docker_image_tag = "hello_world"
    }
  }
}