variable "subscription" {
}

variable "aro_name" {
  default = "rm-aro"
  description 		= "The Azure Red Hat OpenShift 4.x (ARO) name"
}

variable "aro_vnet_resource_group_name" {
  default = "rm-aro-rg"
  description 		= "Name of resource group to deploy ARO VNET/Subnets in."
}

variable "aro_location" {
  description 		= "The ARO location where all resources should be created"
  default     		= "AustraliaEast"
}

variable "tags" {
  description 		= "Tags to apply to all resources created."
  type        		= map(string)
  default     		= {
    Environment 	= "test"
  }
}

variable "aro_client_object_id" {
  description 		= "The Application ID used by the Azure Red Hat OpenShift"
}

variable "aro_client_id" {
  description 		= "The Application ID used by the Azure Red Hat OpenShift"
}

variable "aro_client_secret" {
  description 		= "The Application Secret used by the Azure Red Hat OpenShift"
}


variable "aro_rp_object_id" {
  description 		= "The Resource Provider ID for Azure Red Hat OpenShift"
  default = "034dd685-b7a7-4924-b30b-b4bf8e6448d3"
}

variable "pull-secret" {
  default = {}
}

variable "aro_api_server_visibility" {
    default = "Public"
  description		= "Cluster API and Console visibility. Values are Public/Private"
}

variable "aro_ingress_visibility" {
    default = "Public"
  description		= "API ingress visibility. Values are Public/Private"
}

variable "aro_worker_node_size" {
  description 		= "The ARO Worker nodes size, Default set to Standard_D4s_v3"
  default = "Standard_D4s_v3"
}

variable "aro_worker_node_count" {
  type        		= number
  default     		= 3
  description 		= "The ARO Worker nodes count (Default is 3)"
}

variable "aro_worker_node_disk_size" {
  type        		= number
  default     		= 128
  description 		= "The ARO Worker nodes Disk Size in GigaBytes (Default is 128Gb)"
}

variable "aro_vnet_name" {
 default = "rm-aro-vnet"
  description 		= "The name for ARO Virtual Network"
}

variable "aro_vnet_cidr" {
default = "10.0.0.0/22"
  description 		= "The IP Range assigned to the ARO VNET"
}

variable "aro_master_subnet_name" {
default = "master-subnet"
  description 		= "The Name assigned to the ARO Masters' Subnet"
}

variable "aro_master_subnet_cidr" {
default = "10.0.0.0/23"
  description 		= "The IP Range assigned to the ARO Masters' Subnet"
}

variable "aro_worker_subnet_name" {
  default = "worker-subnet"
  description 		= "The Name assigned to the ARO Workers' Subnet"
}

variable "aro_worker_subnet_cidr" {
default = "10.0.2.0/23"
  description 		= "The IP Range assigned to the ARO Workers' Subnet"
}

variable "service_endpoints" {
  type			= list
  description 		= ""
  default 		= [
    "Microsoft.ContainerRegistry",
    "Microsoft.KeyVault",
    "Microsoft.Storage"
  ]
}

variable "roles" {
  description = "Roles to be assigned to the Principal"
  type        = list(object({ role = string }))
  default = [
    {
      role = "Contributor"
    },
    {
      role = "User Access Administrator"
    }
  ]
}

