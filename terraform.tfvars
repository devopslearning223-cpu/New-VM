# ==========================================
# 1. Region & Resource Group Configuration
# ==========================================
location            = "East US"
resource_group_name = "rg-devops-bastion-demo"

# ==========================================
# 2. Networking Configuration
# ==========================================
vnet_name          = "vnet-devops-demo"
vnet_address_space = "10.0.0.0/16"
vm_subnet_name     = "snet-workload-private"
vm_subnet_prefix   = "10.0.1.0/24"

# Note: Azure Bastion Subnet prefix MUST be /26 or larger (e.g., /26, /25, /24)
bastion_subnet_prefix = "10.0.2.0/26"

# ==========================================
# 3. Azure Bastion Host Configuration
# ==========================================
bastion_name = "bastion-devops-demo"

# ==========================================
# 4. NAT Gateway Configuration
# ==========================================
nat_gateway_name = "nat-gw-devops-demo"

# ==========================================
# 5. Virtual Machine Configuration
# ==========================================
vm_name        = "vm-private-app"
vm_size        = "Standard_B1s"
admin_username = "azureuser"

# Password Requirements: Minimum 12 characters (uppercase, lowercase, number, special symbol)
admin_password = "ComplexPassword@2026!"

# ==========================================
# 6. Resource Tags
# ==========================================
tags = {
  Environment = "Development"
  Project     = "AI-Pipeline"
  ManagedBy   = "Terraform"
  Owner       = "DevOps-Team"
}
