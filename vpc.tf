data "azurerm_subscription" "current" {
}

output "current_subscription_display_name" {
  value = data.azurerm_subscription.current.display_name
}
resource "azurerm_resource_group" "tier_app" {
  name     = "tier_app"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vpc" {
  name                = "app-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.tier_app.location
  resource_group_name = azurerm_resource_group.tier_app.name
  depends_on = [
    azurerm_resource_group.tier_app
  ]
}

resource "azurerm_subnet" "subnet-1" {
  name                 = "subnet-1"
  resource_group_name  = azurerm_resource_group.tier_app.name
  virtual_network_name = azurerm_virtual_network.vpc.name
  address_prefixes     = ["10.1.0.0/16"]

}
resource "azurerm_subnet" "subnet-2" {
  name                 = "subnet-2"
  resource_group_name  = azurerm_resource_group.tier_app.name
  virtual_network_name = azurerm_virtual_network.vpc.name
  address_prefixes     = ["10.2.0.0/16"]

}


