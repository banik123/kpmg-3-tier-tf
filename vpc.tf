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

resource "azurerm_public_ip" "myvm1publicip" {
  name = "publicip1"
  location = azurerm_resource_group.tier_app.location
  resource_group_name = azurerm_resource_group.tier_app.name
  allocation_method = "Dynamic"
  sku = "Basic"
  depends_on = [
    azurerm_resource_group.tier_app,

  ]
}

resource "azurerm_network_interface" "myvm1nic" {
  name = "myvm1-nic"
  location = azurerm_resource_group.tier_app.location
  resource_group_name = azurerm_resource_group.tier_app.name

  ip_configuration {
    name = "ipconfig1"
    subnet_id = azurerm_subnet.subnet-1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.myvm1publicip.id
  }
    depends_on = [
    azurerm_public_ip.myvm1publicip,
    azurerm_virtual_network.vpc
  ]
}


