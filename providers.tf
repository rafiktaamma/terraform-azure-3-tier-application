provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.78.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.1"
    }
  }
}