/*
 * Esta configuración usa dos zonas de Azure para saltar la restricción de 4
 * vCPUs por zona. Ambas zonas se comunican entre sí usando peering.
 * Así, Jenkins podría comunicarse con el cluster Kubernetes y vice versa.
 */


resource "azurerm_resource_group" "rg-cicd" {
  name     = var.rg_cicd_name
  location = var.rg_cicd_location

  tags = {
    "project" = var.rg_group
  }
}

# Kubernetes cluster
resource "azurerm_virtual_network" "vnet-k8s" {
  name                = var.vnet_k8s_name
  address_space       = var.vnet_k8s_address_space
  location            = var.k8s_location
  resource_group_name = azurerm_resource_group.rg-cicd.name
}

resource "azurerm_subnet" "subnet-k8s" {
  name                 = var.k8s_subnet_name
  resource_group_name  = azurerm_resource_group.rg-cicd.name
  virtual_network_name = azurerm_virtual_network.vnet-k8s.name
  address_prefixes     = var.k8s_subnet_address_prefixes
}

resource "azurerm_container_registry" "acr-k8s" {
  name                = var.acr_name
  location            = var.k8s_location
  resource_group_name = azurerm_resource_group.rg-cicd.name
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
}

resource "azurerm_kubernetes_cluster" "aks-k8s" {
  name                              = var.aks_name
  location                          = var.k8s_location
  resource_group_name               = azurerm_resource_group.rg-cicd.name
  dns_prefix                        = var.aks_dns_prefix
  kubernetes_version                = "1.24.6"
  role_based_access_control_enabled = true

  default_node_pool {
    name                = var.aks_np_name
    node_count          = var.aks_np_node_count
    vm_size             = var.aks_np_vm_size
    vnet_subnet_id      = azurerm_subnet.subnet-k8s.id
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 2
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    service_cidr = var.aks_netp_service_cidr
    dns_service_ip = var.aks_netp_dns_service_ip
    docker_bridge_cidr = var.aks_netp_docker_bridge_cidr
  }

  service_principal {
    client_id     = var.aks_sp_client_id
    client_secret = var.aks_sp_client_secret
  }
}

# Jenkins server
resource "azurerm_virtual_network" "vnet-jenkins" {
  name                = var.vnet_jenkins_name
  address_space       = var.vnet_jenkins_address_space
  location            = var.jenkins_location
  resource_group_name = azurerm_resource_group.rg-cicd.name
}

resource "azurerm_subnet" "subnet-jenkins" {
  name                 = var.jenkins_subnet_name
  resource_group_name  = azurerm_resource_group.rg-cicd.name
  virtual_network_name = azurerm_virtual_network.vnet-jenkins.name
  address_prefixes     = var.jenkins_subnet_address_prefixes
}

resource "azurerm_public_ip" "pubip-jenkinssrv" {
    name = var.jenkins_pubip_name
    resource_group_name = azurerm_resource_group.rg-cicd.name
    location = var.jenkins_location
    domain_name_label = var.pubip_dns_label
    allocation_method = "Static"
}

resource "azurerm_network_interface" "veth-jenkinssrv" {
    name = var.jenkins_veth_name
    resource_group_name = azurerm_resource_group.rg-cicd.name
    location = var.jenkins_location

    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.subnet-jenkins.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.pubip-jenkinssrv.id
    }
}

resource "azurerm_linux_virtual_machine" "jenkins-vm" {
    name = var.jenkins_vm_name
    resource_group_name = azurerm_resource_group.rg-cicd.name
    location = var.jenkins_location
    size = var.jenkins_vm_instance_type
    network_interface_ids = [ azurerm_network_interface.veth-jenkinssrv.id ]
    computer_name = var.jenkins_vm_name

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts"
        version = "latest"
    }

    admin_username = var.jenkins_vm_admin_username
    admin_ssh_key {
        username = var.jenkins_vm_admin_username
        public_key = file(var.jenkins_vm_admin_public_key)
    }
}

# Connect both vnets using network peering
resource "azurerm_virtual_network_peering" "netpeer-aks-jenkins" {
  name = var.vnetpeer_aks2jenkins_name
  resource_group_name = azurerm_resource_group.rg-cicd.name
  virtual_network_name = azurerm_virtual_network.vnet-k8s.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-jenkins.id
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
  allow_gateway_transit = false
}

resource "azurerm_virtual_network_peering" "netpeer-jenkins-aks" {
  name = var.vnetpeer_jenkins2aks_name
  resource_group_name = azurerm_resource_group.rg-cicd.name
  virtual_network_name = azurerm_virtual_network.vnet-jenkins.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-k8s.id
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
  allow_gateway_transit = false
}