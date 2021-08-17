variable "base_name" {
  type        = string
  description = "A base for the naming scheme."
}

variable "location" {
  type        = string
  description = "The Azure region where the resources will be created."
}

resource "azurerm_resource_group" "group" {
  name     = var.base_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.base_name}-vnet"
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "ase" {
  name                 = "ase-subnet"
  resource_group_name  = azurerm_resource_group.group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "ase-subnet-delegation"
    service_delegation {
      name    = "Microsoft.Web/hostingEnvironments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_app_service_environment_v3" "ase" {
  name                = "${var.base_name}-ase"
  resource_group_name = azurerm_resource_group.group.name
  subnet_id           = azurerm_subnet.ase.id
}

# resource "azurerm_app_service_plan" "lnxplan" {
#   name                = "${var.base_name}-lnx-plan"
#   resource_group_name = azurerm_resource_group.group.name
#   location            = azurerm_resource_group.group.location
#   kind                = "Linux"
#   reserved            = true

#   app_service_environment_id = azurerm_app_service_environment.ase.id

#   sku {
#     tier     = "Isolated"
#     size     = "I1"
#     capacity = "1"
#   }
# }

# resource "azurerm_app_service" "lnxapp" {
#   name                = "${var.base_name}-lnx-app"
#   resource_group_name = azurerm_resource_group.group.name
#   location            = azurerm_resource_group.group.location
#   app_service_plan_id = azurerm_app_service_plan.lnxplan.id
  
#   site_config {
#     always_on          = true
#     linux_fx_version = "DOCKER|mcr.microsoft.com/dotnet/core/samples:aspnetapp"
#   }
  
#   app_settings = {
#     DOCKER_CUSTOM_IMAGE_NAME            = "https://mcr.microsoft.com/dotnet/core/samples:aspnetapp"
#     DOCKER_REGISTRY_SERVER_URL          = "https://mcr.microsoft.com"
#     WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
#     WEBSITE_VNET_ROUTE_ALL              = 1
#   }
  
#   lifecycle {
#     ignore_changes = [
#       app_settings.DOCKER_CUSTOM_IMAGE_NAME,
#       site_config.0.linux_fx_version,
#       site_config.0.scm_type
#     ]
#   }
# }

# resource "azurerm_app_service_plan" "winplan" {
#   name                = "${var.base_name}-win-plan"
#   resource_group_name = azurerm_resource_group.group.name
#   location            = azurerm_resource_group.group.location
#   kind                = "Windows"
#   reserved            = false

#   app_service_environment_id = azurerm_app_service_environment.ase.id

#   sku {
#     tier     = "Isolated"
#     size     = "I1"
#     capacity = "1"
#   }
# }

# resource "azurerm_app_service" "winapp" {
#   name                = "${var.base_name}-win-app"
#   resource_group_name = azurerm_resource_group.group.name
#   location            = azurerm_resource_group.group.location
#   app_service_plan_id = azurerm_app_service_plan.winplan.id
# }