# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# 1b. New Resource Group: rg-learner
resource "azurerm_resource_group" "rg_learner" {
  name     = "rg-learner"
  location = "East US"
  tags     = var.tags
}


# 2. Virtual Network (VNet)
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

# 3. Subnet for Workload / Private VM
resource "azurerm_subnet" "vm_subnet" {
  name                 = var.vm_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.vm_subnet_prefix]
}

# 4. Subnet for Azure Bastion (Name MUST strictly be 'AzureBastionSubnet')
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.bastion_subnet_prefix]
}

# 5. Public IP for Azure Bastion (Standard SKU & Static Required)
resource "azurerm_public_ip" "bastion_pip" {
  name                = "${var.bastion_name}-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# 6. Azure Bastion Host
resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }

  tags = var.tags
}

# 7. Public IP for NAT Gateway
resource "azurerm_public_ip" "nat_pip" {
  name                = "${var.nat_gateway_name}-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# 8. Azure NAT Gateway
resource "azurerm_nat_gateway" "nat_gw" {
  name                    = var.nat_gateway_name
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  tags                    = var.tags
}

# 9. Associate Public IP to NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "nat_pip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gw.id
  public_ip_address_id = azurerm_public_ip.nat_pip.id
}

# 10. Associate NAT Gateway with VM Subnet (enables outbound internet for private VM)
resource "azurerm_subnet_nat_gateway_association" "vm_subnet_nat_assoc" {
  subnet_id      = azurerm_subnet.vm_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}

# 11. Network Interface for VM (Private IP only)
resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

# 12. Linux Virtual Machine (Ubuntu 22.04 LTS)
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.vm_name
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = var.tags
}
