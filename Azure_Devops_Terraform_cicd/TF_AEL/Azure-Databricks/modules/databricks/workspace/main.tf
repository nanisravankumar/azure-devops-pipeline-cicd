terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
  required_version = ">= 0.14.9"
}

resource "azurerm_databricks_workspace" "workspace" {
  name                                  = var.name
  resource_group_name                   = var.resource_group_name
  location                              = var.location
  sku                                   = var.sku
  tags                                  = var.tags
  managed_resource_group_name           = "MRG-${var.name}"
  public_network_access_enabled         = var.public_network_access_enabled
  network_security_group_rules_required = "NoAzureDatabricksRules"

  custom_parameters {
    no_public_ip                                         = var.no_public_ip
    virtual_network_id                                   = var.vnet_id
    private_subnet_name                                  = var.public_subnet_name
    public_subnet_name                                   = var.private_subnet_name
    public_subnet_network_security_group_association_id  = var.public_subnet_network_security_group_association_id #"/subscriptions/f33ad4d2-0349-41ba-8225-c808491d4610/resourceGroups/IC-Common-Prod-RG/providers/Microsoft.Network/networkSecurityGroups/IC-Common-Prod-VNET-DBRKS-NSG-01"
    private_subnet_network_security_group_association_id = var.private_subnet_network_security_group_association_id #"/subscriptions/f33ad4d2-0349-41ba-8225-c808491d4610/resourceGroups/IC-Common-Prod-RG/providers/Microsoft.Network/networkSecurityGroups/IC-Common-Prod-VNET-DBRKS-NSG-02"
  }

  # We need this, otherwise destroy doesn't cleanup things correctly
  // depends_on = [
  //   azurerm_subnet_network_security_group_association.public,
  //   azurerm_subnet_network_security_group_association.private
  // ]
}


# Private Endpoint

module "databricks_private_endpoint" {
  source              = "../../private-endpoint"
  name                = "${azurerm_databricks_workspace.workspace.name}-PE-UI"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id                      = var.pe_subnet_id
  tags                           = var.tags
  private_connection_resource_id = azurerm_databricks_workspace.workspace.id
  is_manual_connection           = false
  subresource_name               = "databricks_ui_api"
}

module "databricks_bw_private_endpoint" {
  source              = "../../private-endpoint"
  name                = "${azurerm_databricks_workspace.workspace.name}-PE-Auth"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id                      = var.pe_subnet_id
  tags                           = var.tags
  private_connection_resource_id = azurerm_databricks_workspace.workspace.id
  is_manual_connection           = false
  subresource_name               = "browser_authentication"
}
