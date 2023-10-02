resource "azuread_group" "aks_administrators" {
  display_name        = "cluster-administrators"
  security_enabled = true
  description = "Azure AKS Kubernetes administrators for the ${azurerm_kubernetes_cluster.k8s.name}."
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
    os_disk_size_gb = 30
    node_labels = {
      "environment"      = "dev"
    } 
   tags = {
      "environment"      = "dev"
   }
  }
azure_active_directory_role_based_access_control {
  managed = true
  admin_group_object_ids = [azuread_group.aks_administrators.id]
}    
  linux_profile {
    admin_username = d1admin
    ssh_key {
      key_data = file(var.ssh_public_key)
    }


  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}