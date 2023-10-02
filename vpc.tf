resource "azurerm_resource_group" "3-tier" {
  name     = "3-tier"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vpc" {
  name                = "3-tier-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.3-tier.location
  resource_group_name = azurerm_resource_group.3-tier.name
  depends_on = [
    azurerm_resource_group.3-tier
  ]
}

resource "azurerm_subnet" "subnet-1" {
  name                 = "subnet-1"
  resource_group_name  = azurerm_resource_group.vpc.name
  virtual_network_name = azurerm_virtual_network.vpc.name
  address_prefixes     = ["10.1.0.0/16"]

}
resource "azurerm_subnet" "subnet-2" {
  name                 = "subnet-2"
  resource_group_name  = azurerm_resource_group.vpc.name
  virtual_network_name = azurerm_virtual_network.vpc.name
  address_prefixes     = ["10.2.0.0/16"]

}


