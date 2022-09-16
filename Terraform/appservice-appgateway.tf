
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

variable "virtual_network_id" {
  default = "/subscriptions/7d743f3c-f61e-488a-bfb3-eed5932a6259/resourceGroups/build-agents-templates/providers/Microsoft.Network/virtualNetworks/build-agents-vnet"
}

variable "subnet_id" {
  default = "/subscriptions/7d743f3c-f61e-488a-bfb3-eed5932a6259/resourceGroups/build-agents-templates/providers/Microsoft.Network/virtualNetworks/build-agents-vnet/subnets/appgateway-subnet"
}

resource "azurerm_public_ip" "pip1" {
  name                = "AGPublicIPAddress"
  resource_group_name = "build-agents-terraform"
  location            = "westeurope"
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_application_gateway" "nappservice" {
  name                = "terraform-AppGateway"
  resource_group_name = "build-agents-terraform"
  location            = "westeurope"

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.subnet_id
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
    fqdns = ["linux-app-service.azurewebsites.net", "linux-app-service-2.azurewebsites.net", "capgemlinuxwebapp.azurewebsites.net"]
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