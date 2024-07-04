# #----------#
# # ADF ROLE ASSIGNMENTS
# #----------#
resource "azurerm_role_assignment" "adf_to_adls_access" {
  scope                = data.azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.data_factory.principal_id
  depends_on           = [data.azurerm_storage_account.storage_account, module.data_factory]
}

resource "azurerm_role_assignment" "adf_to_kv_access" {
  scope                = data.azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.data_factory.principal_id
  depends_on           = [data.azurerm_key_vault.key_vault, module.data_factory]
}

resource "azurerm_kusto_database_principal_assignment" "adf_to_kusto_database_access" {
  name                = "KustoPrincipalAssignment"
  resource_group_name = data.azurerm_resource_group.rg.name
  cluster_name        = data.azurerm_kusto_cluster.data_factory_explorer.name
  database_name       = data.azurerm_kusto_database.data_factory_database.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  principal_id        = module.data_factory.principal_id
  principal_type      = "App"
  role                = "User"
  depends_on          = [data.azurerm_kusto_database.data_factory_database, module.data_factory]
}

resource "azurerm_kusto_cluster_principal_assignment" "adf_to_kusto_cluster_access" {
  name                = "KustoPrincipalAssignment"
  resource_group_name = data.azurerm_resource_group.rg.name
  cluster_name        = data.azurerm_kusto_cluster.data_factory_explorer.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  principal_id        = module.data_factory.principal_id
  principal_type      = "App"
  role                = "AllDatabasesViewer"
}

resource "azurerm_role_assignment" "adf_to_adb_access" {
  scope                = data.azurerm_databricks_workspace.databricks_data_factory.id
  role_definition_name = "Contributor"
  principal_id         = module.data_factory.principal_id
  depends_on           = [data.azurerm_databricks_workspace.databricks_data_factory, module.data_factory]
}





