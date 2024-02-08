
## Network 
# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  tags = {
    environment = "production"
  }
}

# Create subnet (public subnet for the frontend application and 2 private subnet for the backend and db)
resource "azurerm_subnet" "web_tier_subnet" {
  name                 = var.web_tier_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "business_tier_subnet" {
  name                 = var.business_tier_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "data_tier_subnet" {
  name                 = var.data_tier_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}



# Create public IPs (For frontend Application only ) 
# As First step i will create 3 public ips for each machine 
resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  domain_name_label = "${var.dns_label_prefix}-web-app"
  tags = {
    environment = "production"
  }
}
# Temporary
resource "azurerm_public_ip" "business_public_ip" {
  name                = "business_public_ip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  domain_name_label = "${var.dns_label_prefix}-business-app"

  tags = {
    environment = "production"
  }
}
# Temporary
resource "azurerm_public_ip" "data_public_ip" {
  name                = "data_public_ip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  domain_name_label = "${var.dns_label_prefix}-data-app"

  tags = {
    environment = "production"
  }
}

## Create Network Security Group and rule (I will create nsg for each subnet , the nsg will allow ssh and for tcp for some ports)
# WEB TIER
resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "production"
  }
}

# BUSINESS TIER
// TODO : Fixing the real source adrdress prefix
resource "azurerm_network_security_group" "nsg_business_tier" {
  name                = var.nsg_business_tier_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    description                = "Allowing SSH connections"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "TCP_8080"
    description                = "Allowing TCP Connection from the Web Tier subnet"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "production"
  }
}

# DATA TIER
resource "azurerm_network_security_group" "nsg_data_tier" {
  name                = var.nsg_data_tier_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "TCP_3306"
    description                = "Allowing TCP Connection from the Business Tier subnet on port 3306"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "production"
  }
}

## Create network interfaces for each VM 
# WEB TIER
resource "azurerm_network_interface" "nic" {
  name                = var.network_interface_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.web_tier_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = {
    environment = "production"
  }
}

# BUSNIESS TIER
resource "azurerm_network_interface" "nic_business_tier" {
  name                = var.nic_business_tier_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.business_tier_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.business_public_ip.id
  }

  tags = {
    environment = "production"
  }
}
# DATA TIER
resource "azurerm_network_interface" "nic_data_tier" {
  name                = var.nic_data_tier_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.data_tier_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.data_public_ip.id
  }

  tags = {
    environment = "production"
  }
}


# Connect the security groups to the network interfaces
resource "azurerm_network_interface_security_group_association" "web_association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
resource "azurerm_network_interface_security_group_association" "business_association" {
  network_interface_id      = azurerm_network_interface.nic_business_tier.id
  network_security_group_id = azurerm_network_security_group.nsg_business_tier.id
}
resource "azurerm_network_interface_security_group_association" "data_association" {
  network_interface_id      = azurerm_network_interface.nic_data_tier.id
  network_security_group_id = azurerm_network_security_group.nsg_data_tier.id
}


# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = var.resource_group_name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "storage" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "production"
  }
}

# Create (and display) an SSH key
resource "tls_private_key" "tls_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Saving the private ssh key (I will be the same key to access all machines)
resource "local_file" "cloud_pem" {
  filename = "${path.module}/${var.private_key_name}.pem"
  content  = tls_private_key.tls_ssh.private_key_pem
}

# Creating virtual machine
# WEB TIER
resource "azurerm_linux_virtual_machine" "web_app" {
  name                  = var.web_app_name
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "${var.web_app_name}_OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "webApp"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.tls_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage.primary_blob_endpoint
  }

  tags = {
    environment = "production"
  }
}


# BUSINESS TIER
resource "azurerm_linux_virtual_machine" "business_app" {
  name                  = var.business_app_name
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic_business_tier.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "${var.business_app_name}-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "businessApp"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.tls_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage.primary_blob_endpoint
  }

  tags = {
    environment = "production"
  }
}

# DATA TIER
resource "azurerm_linux_virtual_machine" "data_app" {
  name                  = var.data_app_name
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic_data_tier.id]
  size                  = "Standard_B2als_v2"

  os_disk {
    name                 = "${var.data_app_name}-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

   source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "dataApp"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.tls_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage.primary_blob_endpoint
  }

  tags = {
    environment = "production"
  }
}