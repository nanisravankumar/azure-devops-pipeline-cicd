module "databricks" {
  source                        = "./modules/databricks/workspace"
  name                          = var.databricks_name
  location                      = data.azurerm_resource_group.resource_group_name.location
  resource_group_name           = data.azurerm_resource_group.resource_group_name.name
  tags                          = var.tags
  sku                           = var.sku #"premium"
  public_network_access_enabled = true
  no_public_ip                  = true
  vnet_id                       = data.azurerm_virtual_network.vnet.id
  public_subnet_id              = data.azurerm_subnet.adbpub_subnet.id
  public_subnet_name            = data.azurerm_subnet.adbpub_subnet.name
  private_subnet_id             = data.azurerm_subnet.adbpri_subnet.id
  private_subnet_name           = data.azurerm_subnet.adbpri_subnet.name
  subscription_id               = data.azurerm_client_config.current.subscription_id
  vnet_rg_name                  = var.vnet_rg_name
  vnet_name                     = var.vnet_name
  pe_subnet_id                  = data.azurerm_subnet.endpoint_subnet.id
  public_subnet_network_security_group_association_id = var.public_subnet_network_security_group_association_id
  private_subnet_network_security_group_association_id = var.private_subnet_network_security_group_association_id
}

module "databricks_cluster" {
  source                   = "./modules/databricks/cluster"
  cluster_name             = var.cluster_name #"adani-adb-cluster"
  node_type_id             = var.node_type_id #"Standard_D4a_v4"    #Standard_D8a_v4  #Standard_DS3_v2
  driver_node_type_id      = var.driver_node_type_id 
  spark_version            = var.spark_version #"13.2.x-scala2.12"
  autotermination_minutes  = var.autotermination_minutes #60
  min_workers              = var.min_workers #2
  max_workers              = var.max_workers #4
  keyvault_id              = data.azurerm_key_vault.key_vault.id
  keuvault_uri             = data.azurerm_key_vault.key_vault.vault_uri
//   container_id             = data.azurerm_storage_account.storage_account_name.resource_manager_id
//   storage_account_name     = data.azurerm_storage_account.storage_account_name.name
//   databricks_client_id     = azuread_application.service_principal.application_id
//   databricks_client_secret = azurerm_key_vault_secret.adb_svc_pass.value
//   tenant_id                = data.azuread_client_config.current.tenant_id

  depends_on = [module.databricks, data.azurerm_storage_account.storage_account_name]
}