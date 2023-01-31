rg_group = 4
rg_cicd_name = "rg-s2-cicd"
rg_cicd_location = "eastus2"

k8s_location = "eastus"
jenkins_location = "eastus2"

# K8s cluster is on East US
vnet_k8s_name = "vnet-k8s"
vnet_k8s_address_space = [ "10.1.0.0/16" ]

k8s_subnet_name = "subnet-k8s"
k8s_subnet_address_prefixes = [ "10.1.128.0/20" ]

acr_name = "usachdevopssec2g4ns"
acr_sku = "Basic"
acr_admin_enabled = true

aks_name = "aks-sec2"
aks_dns_prefix = "aks1" 
aks_np_name = "default"
aks_np_node_count = 1
aks_np_vm_size = "Standard_B2s"
aks_np_min_count = 1
aks_np_max_count = 2
aks_netp_service_cidr = "10.0.0.0/20"
aks_netp_dns_service_ip = "10.0.0.10"
aks_netp_docker_bridge_cidr = "172.17.0.1/16"
aks_sp_client_id = "SECRET"
aks_sp_client_secret = "SECRET"

# Jenkins CI is on East US
vnet_jenkins_name = "vnet-jenkins"
vnet_jenkins_address_space = [ "10.2.0.0/16" ]

jenkins_subnet_name = "subnet-jenkins"
jenkins_subnet_address_prefixes = [ "10.2.0.0/24" ]

jenkins_pubip_name = "pubip-jenkins"
pubip_dns_label = "usach-devops-s2g4-ns"

jenkins_veth_name = "veth-jenkinssrv"

jenkins_vm_name = "vm-jenkins"
jenkins_vm_instance_type = "Standard_B1ms"
jenkins_vm_admin_username = "nico"
jenkins_vm_admin_public_key = "/home/nico/.ssh/id_rsa.pub"


# Peering
vnetpeer_aks2jenkins_name = "peer-aks2jenkins"
vnetpeer_jenkins2aks_name = "peer-jenkins2aks"