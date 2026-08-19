output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Resource Group Name"
}

output "learner_resource_group_name" {
  value       = azurerm_resource_group.rg_learner.name
  description = "Learner Resource Group Name"
}


output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "Virtual Network Name"
}

output "vm_subnet_id" {
  value       = azurerm_subnet.vm_subnet.id
  description = "VM Subnet ID"
}

output "bastion_subnet_id" {
  value       = azurerm_subnet.bastion_subnet.id
  description = "Azure Bastion Subnet ID"
}

output "bastion_public_ip" {
  value       = azurerm_public_ip.bastion_pip.ip_address
  description = "Public IP assigned to Azure Bastion"
}

output "bastion_name" {
  value       = azurerm_bastion_host.bastion.name
  description = "Azure Bastion Host Name"
}

output "nat_gateway_public_ip" {
  value       = azurerm_public_ip.nat_pip.ip_address
  description = "Public IP assigned to NAT Gateway for Outbound Internet Access"
}

output "vm_private_ip" {
  value       = azurerm_network_interface.vm_nic.private_ip_address
  description = "Private IP address of the Virtual Machine"
}
