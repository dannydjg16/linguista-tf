# main.tf

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "linguista" {
  name     = "linguista-resources"
  location = "East US"
}

resource "azurerm_service_plan" "linguista" {
  name                = "linguista-appserviceplan"
  location            = azurerm_resource_group.linguista.location
  resource_group_name = azurerm_resource_group.linguista.name
  sku_name            = "B1"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "linguista" {
  name                = "linguista-appservice"
  location            = azurerm_resource_group.linguista.location
  resource_group_name = azurerm_resource_group.linguista.name
  service_plan_id     = azurerm_service_plan.linguista.id

  site_config {
    application_stack {
      dotnet_version = var.dotnet8
    }
    app_command_line = "dotnet linguista-api.dll"
    health_check_path = var.healthcheckEndpoint
  }

  # App settings (e.g. OpenAiKey) are managed in Azure, not Terraform
  lifecycle {
    ignore_changes = [app_settings]
  }
}