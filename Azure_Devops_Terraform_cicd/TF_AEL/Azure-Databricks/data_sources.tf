data "azurerm_client_config" "current" {}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg_name
}

data "azurerm_resource_group" "resource_group_name" {
  name = var.resource_group_name
}


data "azurerm_subnet" "endpoint_subnet" {
  name                 = var.pe_subnet_name
  resource_group_name  = var.vnet_rg_name
  virtual_network_name = var.vnet_name
}

data "azurerm_subnet" "adbpub_subnet" {
  name                 = var.adbpub_subnet_name
  resource_group_name  = var.vnet_rg_name
  virtual_network_name = var.vnet_name
}

data "azurerm_subnet" "adbpri_subnet" {
  name                 = var.adbpri_subnet_name
  resource_group_name  = var.vnet_rg_name
  virtual_network_name = var.vnet_name
}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_storage_account" "storage_account_name" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

data "azurerm_kusto_cluster" "kusto_cluster" {
  name                = var.kusto_cluster_name #"az01adxcp01"
  resource_group_name = var.resource_group_name
}


data "azurerm_kusto_database" "adb_kusto_database" {
  name               = var.kusto_database_name
  cluster_name       = data.azurerm_kusto_cluster.kusto_cluster.name
  resource_group_name = var.resource_group_name
}


