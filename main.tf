terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.37.0"
    }
  }
  # whilst the `version` attribute is optional, I recommend pinning to a given version of the Provider
  required_version = "= 0.13.5"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription
}

data "azurerm_client_config" "current" {}


resource "azurerm_resource_group" "aro_vnet_resource_group" {
  name     		= var.aro_vnet_resource_group_name
  location 		= var.aro_location

  tags			= var.tags
}

resource "azurerm_virtual_network" "aro_vnet" {
  name                	= var.aro_vnet_name
  resource_group_name 	= azurerm_resource_group.aro_vnet_resource_group.name 
  location            	= azurerm_resource_group.aro_vnet_resource_group.location
  address_space       	= [var.aro_vnet_cidr]
}

resource "azurerm_subnet" "aro_master_subnet" {
  name                 	= var.aro_master_subnet_name
  virtual_network_name 	= azurerm_virtual_network.aro_vnet.name
  resource_group_name  	= azurerm_resource_group.aro_vnet_resource_group.name 
  address_prefixes 	= [var.aro_master_subnet_cidr]

  enforce_private_link_service_network_policies = true

  service_endpoints 	= var.service_endpoints
}

resource "azurerm_subnet" "aro_worker_subnet" {
  name                 	= var.aro_worker_subnet_name
  virtual_network_name 	= azurerm_virtual_network.aro_vnet.name
  resource_group_name  	= azurerm_resource_group.aro_vnet_resource_group.name 
  address_prefixes 	= [var.aro_worker_subnet_cidr]

  service_endpoints 	= var.service_endpoints
}

resource "azurerm_role_assignment" "vnet_assignment" {
  count			= length(var.roles)
  scope			= azurerm_virtual_network.aro_vnet.id
  role_definition_name	= var.roles[count.index].role
  principal_id		= var.aro_client_object_id
}

resource "azurerm_role_assignment" "rp_assignment" {
  count			= length(var.roles)
  scope			= azurerm_virtual_network.aro_vnet.id
  role_definition_name	= var.roles[count.index].role
  principal_id		= var.aro_rp_object_id
}

resource "azurerm_template_deployment" "azure-arocluster" {
  name			= var.aro_name
  resource_group_name	= var.aro_vnet_resource_group_name

  template_body = file("${path.module}/Microsoft.AzureRedHatOpenShift.json")

  parameters 		= {
    clusterName			= var.aro_name
    clusterResourceGroupName 	= join("-", [var.aro_vnet_resource_group_name, "MANAGED"])
    location			= var.aro_location

    tags			= jsonencode(var.tags)

    apiServerVisibility		= var.aro_api_server_visibility
    ingressVisibility		= var.aro_ingress_visibility

    aadClientId			= var.aro_client_id
    aadClientSecret		= var.aro_client_secret

    clusterVnetId		= azurerm_virtual_network.aro_vnet.id
    workerSubnetId		= azurerm_subnet.aro_worker_subnet.id
    masterSubnetId		= azurerm_subnet.aro_master_subnet.id

    workerCount			= var.aro_worker_node_count
    workerVmSize		= var.aro_worker_node_size

    pullSecret               = file("${path.module}/pull-secret.txt")
  }

  deployment_mode 	= "Incremental"

  timeouts {
    create = "90m"
  }

  depends_on		= [
    azurerm_role_assignment.vnet_assignment,
    azurerm_role_assignment.rp_assignment,
  ]
}

