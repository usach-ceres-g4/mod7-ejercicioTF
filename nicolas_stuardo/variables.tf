# Resource group
variable "rg_cicd_name" {}
variable "rg_cicd_location" {}
variable "rg_group" {}

# Locations
variable "k8s_location" {}
variable "jenkins_location" {}

# Virtual network
variable "vnet_k8s_name" {}
variable "vnet_k8s_address_space" {}
variable "vnet_jenkins_name" {}
variable "vnet_jenkins_address_space" {}

# VNet peering
variable "vnetpeer_aks2jenkins_name" {}
variable "vnetpeer_jenkins2aks_name" {}

# Servers subnet
variable "jenkins_subnet_name" {}
variable "jenkins_subnet_address_prefixes" {}

# Jenkins Public IP
variable "jenkins_pubip_name" {}
variable "pubip_dns_label" {}

# Jenkins server network interface
variable "jenkins_veth_name" {}

# Jenkins server VM
variable "jenkins_vm_name" {}
variable "jenkins_vm_instance_type" {}
variable "jenkins_vm_admin_username" {}
variable "jenkins_vm_admin_public_key" {}

# K8s Subnet
variable "k8s_subnet_name" {}
variable "k8s_subnet_address_prefixes" {}

# Container registry
variable "acr_name" {}
variable "acr_sku" {}
variable "acr_admin_enabled" {}

# K8s cluster
variable "aks_name" {}
variable "aks_dns_prefix" {}

## Default node pool
variable "aks_np_name" {}
variable "aks_np_node_count" {}
variable "aks_np_vm_size" {}
variable "aks_np_min_count" {}
variable "aks_np_max_count" {}

## Extra noode pool
variable "aks_np2_name" {}
variable "aks_np2_node_count" {}
variable "aks_np2_vm_size" {}
variable "aks_np2_min_count" {}
variable "aks_np2_max_count" {}

## Network profile
variable "aks_netp_service_cidr" {}
variable "aks_netp_dns_service_ip" {}
variable "aks_netp_docker_bridge_cidr" {}


## Service principals
variable "aks_sp_client_id" {}
variable "aks_sp_client_secret" {}