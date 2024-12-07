provider "azurerm" {
  features {}
  use_msi                        = true
  subscription_id                = "4e6b132a-5ee7-4a06-9850-795d055dd655"
  resource_provider_registrations = "none"
}

data "azurerm_resource_group" "existing" {
  name = "TP_terraform"
}

resource "random_id" "suffix" {
  byte_length = 2
}

resource "azurerm_service_plan" "example" {
  name                = "serviceplan-${random_id.suffix.hex}"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name

  sku_name = "B1"      # Basic tier for custom containers
  os_type  = "Linux"
}

resource "azurerm_linux_web_app" "example" {
  name                = "web-app-${random_id.suffix.hex}" # Ensure a globally unique name
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
  service_plan_id     = azurerm_service_plan.example.id

  site_config {
    always_on     = false
    http2_enabled = true
  }

  app_settings = {
    "DOCKER_ENABLE_CI"       = "true"
    "DOCKER_CUSTOM_IMAGE_NAME" = var.docker_image
  }

  identity {
    type = "SystemAssigned"
  }
}

# Terraform variable for the Docker image
variable "docker_image" {
  default = "nginx:latest"
}

output "web_app_name" {
  value = azurerm_linux_web_app.example.name
}
