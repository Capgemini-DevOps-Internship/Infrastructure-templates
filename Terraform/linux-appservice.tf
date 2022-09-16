
resource "azurerm_service_plan" "appserviceplan" {
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
  service_plan_id     = azurerm_service_plan.appserviceplan.id

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