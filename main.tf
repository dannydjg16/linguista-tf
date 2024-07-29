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
      dotnet_version = "8.0"
    }
    app_command_line = "dotnet linguista-api.dll"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  
#   connection_string {
#     name  = "DefaultConnection"
#     type  = "SQLAzure"
#     value = "Database=mydb;Data Source=mydbserver;User Id=mylogin;Password=mypassword;"
#   }
}