provider "azurerm" {
  features {}
  use_msi                        = true
  subscription_id                = var.subscription_id
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
    application_stack {
      docker_image_name   = var.docker_image
      docker_registry_url = "https://index.docker.io"
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

# Terraform variables
variable "subscription_id" {
  description = "Azure subscription ID"
}

variable "docker_image" {
  description = "Docker image to deploy"
}
