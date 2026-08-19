variable "location" {
  type        = string
  default     = "East US"
  description = "Azure Region for resources"
}

variable "resource_group_name" {
  type        = string
  default     = "rg-devops-bastion-demo"
  description = "Name of the Resource Group"
}

variable "vnet_name" {
  type        = string
  default     = "vnet-devops-demo"
  description = "Name of the Virtual Network"
}

variable "vnet_address_space" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Address space for the Virtual Network"
}

variable "vm_subnet_name" {
  type        = string
  default     = "snet-workload-private"
  description = "Subnet for the VM"
}

variable "vm_subnet_prefix" {
  type        = string
  default     = "10.0.1.0/24"
  description = "Address prefix for VM subnet"
}

variable "bastion_subnet_prefix" {
  type        = string
  default     = "10.0.2.0/26"
  description = "Address prefix for Azure Bastion Subnet (Must be /26 or larger)"
}

variable "bastion_name" {
  type        = string
  default     = "bastion-devops-demo"
  description = "Name of the Azure Bastion host"
}

variable "nat_gateway_name" {
  type        = string
  default     = "nat-gw-devops-demo"
  description = "Name of the Azure NAT Gateway"
}

variable "vm_name" {
  type        = string
  default     = "vm-private-app"
  description = "Name of the Virtual Machine"
}

variable "vm_size" {
  type        = string
  default     = "Standard_B1s"
  description = "Size of the Virtual Machine"
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "Admin username for VM"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Admin password for VM (must meet Azure complexity requirements)"
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "Development"
    Project     = "AI-Pipeline"
    ManagedBy   = "Terraform"
    Owner       = "DevOps-Team"
  }
  description = "Tags to apply to all resources"
}
