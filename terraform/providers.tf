terraform {
  required_version = ">= 1.0"
  
  backend "azurerm" {
    environment = "public"
  }

  required_providers {
    azurerm = {
      version = "~> 2.62"
    }
  }
}

provider "azurerm" {
  features { }
}