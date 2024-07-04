data "azurerm_network_security_group" "public" {
  name                = "IC-Common-Prod-VNET-DBRKS-NSG-01"
  resource_group_name = var.resource_group_name
}

data "azurerm_network_security_group" "private" {
  name                = "IC-Common-Prod-VNET-DBRKS-NSG-02"
  resource_group_name = var.resource_group_name
}