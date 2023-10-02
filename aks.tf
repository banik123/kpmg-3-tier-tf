resource "azuread_group" "aks_administrators" {
  name        = "cluster-administrators"
  description = "Azure AKS Kubernetes administrators for the ${var.aks_cluster_name}."
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.tier_app.location
  name                = var.aks_cluster_name
  resource_group_name = azurerm_resource_group.tier_app.name
  dns_prefix          = random_pet.azurerm_kubernetes_cluster_dns_prefix.id
  kubernetes_version  = "1.26.3"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "apppool"
    vm_size    = "Standard_D2_v2"
    orchestrator_version = "1.26.3"
    availability_zones   = [1, 2]
    enable_auto_scaling  = true
    max_count            = 5
    min_count            = 3
    vnet_subnet_id       = azurerm_subnet.subnet-1.id
    os_type              = "Linux"
    os_disk_size_gb = 30
    node_labels = {
      "environment"      = "dev"
    } 
   tags = {
      "environment"      = "dev"
   }
   role_based_access_control {
    enabled = true
    azure_active_directory {
      managed = true
      admin_group_object_ids = [azuread_group.aks_administrators.id]
    }
  } 
    
  }
  linux_profile {
    admin_username = var.admin_user
    admin_password = var.admin_password
    disable_password_authentication = false

  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}