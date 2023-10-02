resource "azurerm_windows_virtual_machine" "vm" {
  name                  = "vm"  
  location              = azurerm_resource_group.tier_app.location
  resource_group_name   = azurerm_resource_group.tier_app.name
  network_interface_ids = [azurerm_network_interface.myvm1nic.id]
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  admin_password        = "Password123!"

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
    depends_on = [
    azurerm_network_interface.myvm1nic
  ]
   
}