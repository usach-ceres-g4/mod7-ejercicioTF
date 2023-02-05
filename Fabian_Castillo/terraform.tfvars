# Resource Group values
rg_name = "rg-grupo4"
rg_location = "eastus2"
rg_group = 4

# Virtual Network values
vnet_name = "vnet-grupo4"
vnet_address_space = ["10.0.0.0/16"]

# Subnet values
subnet_name = "internal"
subnet_address_prefixes = ["10.0.2.0/24"]

# Container Registry values
acr_name = "MyACR"
acr_sku = "Basic"
acr_admin_enabled = true

# Kubernetes Service values
aks_name = "aks-grupo4"
aks_dns_prefix = "aks1"
aks_kubernetes_version = "1.22.4"
aks_rbac_enabled = true
aks_np_name = "default"
aks_np2_name = "internal"
aks_np_node_count = 1
aks_np_vm_size = "Standard_D2_v3"
aks_np2_vm_size = "Standard_D2_v3"
aks_np_enabled_auto_scaling = true
aks_np_max_count = 3
aks_np_min_count = 1
aks_np_pods = 80
aks_sp_client_id = "SECRET"
aks_sp_client_secret = "SECRET"
aks_net_plugin = "azure"
aks_net_policy = "azure"

