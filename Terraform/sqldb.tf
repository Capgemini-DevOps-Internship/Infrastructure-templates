terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.20.0"
    }
  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
    name     = "build-agents-terraform"
    location = "westeurope"
}

resource "azurerm_mssql_server" "sqlserver" {
    name                         = "capgemsqlserver"
    resource_group_name          = "${azurerm_resource_group.main.name}"
    location                     = "${azurerm_resource_group.main.location}"
    version                      = "12.0"
    administrator_login          = "4dm1n157r470r"
    administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_mssql_firewall_rule" "firewallrule" {
  name                = "AlllowAzureServices"
  resource_group_name = "${azurerm_resource_group.main.name}"
  server_name         = "${azurerm_mssql_server.sqlserver.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
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