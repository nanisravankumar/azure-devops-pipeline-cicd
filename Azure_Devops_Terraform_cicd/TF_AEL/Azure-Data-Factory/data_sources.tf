data "azurerm_client_config" "current" {}


data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg_name
}

data "azurerm_subnet" "endpoint_subnet" {
  name                 = var.pe_subnet_name
  resource_group_name  = var.vnet_rg_name
  virtual_network_name = var.vnet_name
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_kusto_cluster" "data_factory_explorer" {
  name                = var.kusto_cluster_name
  resource_group_name = var.resource_group_name
}

data "azurerm_kusto_database" "data_factory_database" {
  name               = var.kusto_database_name
  cluster_name       = data.azurerm_kusto_cluster.data_factory_explorer.name
  resource_group_name = var.resource_group_name
}
data "azurerm_storage_account" "storage_account" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

data "azurerm_databricks_workspace" "databricks_data_factory" {
  name                = var.databricks_name #"AZ01ADBP01"
  resource_group_name = var.resource_group_name
}

data "azurerm_monitor_action_group" "email_alert" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = var.monitor_action_group_name
}