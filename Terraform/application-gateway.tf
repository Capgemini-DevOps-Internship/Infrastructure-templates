
variable "backend_address_pool_name" {
    default = "myBackendPool"
}

variable "frontend_port_name" {
    default = "myFrontendPort"
}

variable "frontend_ip_configuration_name" {
    default = "myAGIPConfig"
}

variable "http_setting_name" {
    default = "myHTTPsetting"
}

variable "listener_name" {
    default = "myListener"
}

variable "request_routing_rule_name" {
    default = "myRoutingRule"
}

variable "redirect_configuration_name" {
    default = "myRedirectConfig"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "build-agents-vnet"
  resource_group_name = "build-agents-terraform"
  location            = "westeurope"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "agents" {
  name                 = "agents-subnet"
  resource_group_name = "build-agents-terraform"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "jumpbox" {
  name                 = "jumpbox-subnet"
  resource_group_name = "build-agents-terraform"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "appgateway" {
  name                 = "appgateway-subnet"
  resource_group_name = "build-agents-terraform"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "linuxNSG" {
  name                = "linux-nsg"
  location            = "westeurope"
  resource_group_name = "build-agents-terraform"

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "windowsNSG" {
  name                = "windows-nsg"
  location            = "westeurope"
  resource_group_name = "build-agents-terraform"

  security_rule {
    name                       = "AllowRDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "linux" {
  subnet_id                 = azurerm_subnet.agents.id
  network_security_group_id = azurerm_network_security_group.linuxNSG.id
}

resource "azurerm_subnet_network_security_group_association" "windows" {
  subnet_id                 = azurerm_subnet.jumpbox.id
  network_security_group_id = azurerm_network_security_group.windowsNSG.id
}

resource "azurerm_public_ip" "pip1" {
  name                = "AGPublicIPAddress"
  resource_group_name = "build-agents-terraform"
  location            = "westeurope"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "pip2" {
  name                = "WinPublicIPAddress"
  resource_group_name = "build-agents-terraform"
  location            = "westeurope"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "network" {
  name                = "CapgemAppGateway"
  resource_group_name = "build-agents-terraform"
  location            = "westeurope"

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.appgateway.id
  }

  frontend_port {
    name = var.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip1.id
  }

  backend_address_pool {
    name = var.backend_address_pool_name
  }

  backend_http_settings {
    name                  = var.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = var.listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = var.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = var.listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.http_setting_name
    priority = 1
  }
  waf_configuration {
        enabled = true
        firewall_mode = "Prevention"
        rule_set_type = "OWASP"
        rule_set_version = "3.2"
      }
}

resource "azurerm_network_interface" "niclinux" {
  name                = "nic-linux"
  location            = "westeurope"
  resource_group_name = "build-agents-terraform"

  ip_configuration {
    name                          = "nic-ipconfig1"
    subnet_id                     = azurerm_subnet.agents.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nicwindows" {
  name                = "nic-windows"
  location            = "westeurope"
  resource_group_name = "build-agents-terraform"

  ip_configuration {
    name                          = "nic-ipconfig2"
    subnet_id                     = azurerm_subnet.jumpbox.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip2.id
  }
}

resource "random_password" "password" {
  length = 16
  special = true
  lower = true
  upper = true
  number = true
}

resource "azurerm_windows_virtual_machine" "windowsvm" {
  name                = "jumpbox"
  resource_group_name = "build-agents-terraform"
  location            = "westeurope"
  size                = "Standard_DS1_v2"
  admin_username      = "azureadmin"
  admin_password      = random_password.password.result

  network_interface_ids = [
    azurerm_network_interface.nicwindows.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = 127
  }


  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                = "agent"
  resource_group_name = "build-agents-terraform"
  location            = "westeurope"
  size                = "Standard_DS1_v2"
  disable_password_authentication = false
  admin_username      = "azureadmin"
  admin_password      = random_password.password.result

  network_interface_ids = [
    azurerm_network_interface.niclinux.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
