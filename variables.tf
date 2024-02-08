variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "resource_group_location" {
  type        = string
  description = "RG location in Azure"
}

variable "virtual_network_name" {
  type        = string
  description = "VNET name in Azure"
  default     = "VnetTest"
}

variable "web_tier_subnet_name" {
  type        = string
  description = "Web tier Subnet name "
}
variable "business_tier_subnet_name" {
  type        = string
  description = "Business tier subnet name"
}

variable "data_tier_subnet_name" {
  type        = string
  description = "Data tier subnet name"
}

variable "public_ip_name" {
  type        = string
  description = "Public IP name in Azure"
}

variable "network_security_group_name" {
  type        = string
  description = "NSG name in Azure"
}
variable "nsg_web_tier_name" {
  type        = string
  description = "nsg for web tier subnet"
  default     = "nsg_web_tier_subnet"
}

variable "nsg_business_tier_name" {
  type        = string
  description = "nsg for business tier subnet"
  default     = "nsg_business_tier_subnet"
}

variable "nsg_data_tier_name" {
  type        = string
  description = "nsg for data tier subnet"
  default     = "nsg_data_tier_subnet"
}

variable "network_interface_name" {
  type        = string
  description = "NIC name in Azure"
}
variable "nic_web_tier_name" {
  type        = string
  description = "NIC name in Azure"
  default     = "nic_web_tier"
}
variable "nic_business_tier_name" {
  type        = string
  description = "NIC name in Azure"
  default     = "nic_business_tier"
}
variable "nic_data_tier_name" {
  type        = string
  description = "NIC name in Azure"
  default     = "nic_data_tier"
}

variable "web_app_name" {
  type        = string
  description = "Linux VM name in Azure"
  default     = "web_app"
}
variable "business_app_name" {
  type        = string
  description = "Linux VM name in Azure"
  default     = "business_app"
}
variable "data_app_name" {
  type        = string
  description = "Mysql VM name in Azure"
  default     = "data_app"
}

variable "private_key_name" {
  type        = string
  description = "SSH private key name"
  default     = "VM_Private_Key"
}

variable "dns_label_prefix" {
  type =  string
  description = "DNS label prefix for the public ip of the VM"
}