data "azuread_client_config" "current" {}

resource "azurerm_key_vault_secret" "tenant_id" {
  name         = "adani-ic-tenantid"
  key_vault_id = data.azurerm_key_vault.key_vault.id
  value        = data.azuread_client_config.current.tenant_id
}

resource "azurerm_key_vault_secret" "adb_svc_id" {
  name         = "adani-ic-clientid"
  key_vault_id = data.azurerm_key_vault.key_vault.id
  value        = var.application_id
}

resource "azurerm_key_vault_secret" "adb_svc_pass" {
  name         = "adani-ic-secret-id"
  key_vault_id = data.azurerm_key_vault.key_vault.id
  value        = "NME8Q~auk-Ealbz.G~1jUOtEnf.VlKAA9nmPBafi"
}

# #----------#
# # ADB ROLE ASSIGNMENTS
# #----------#

# Assigning the ADB Enterprise Application Service Principal Role to Key Vault
// data "azuread_service_principal" "adb" {
//   display_name = "AzureDatabricks"
// }

resource "azurerm_role_assignment" "adb_enterprise_application_access_to_kv" {
  scope                = data.azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.object_id
//   depends_on           = [module.key_vault]
}

# ## ASSIGN ROLE ASSIGNMENT FOR ADB_SVC_PN TO ADLS

resource "azurerm_role_assignment" "adb_to_adls_access" {
  scope                = data.azurerm_storage_account.storage_account_name.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.object_id
  depends_on           = [data.azurerm_storage_account.storage_account_name, module.databricks]
}

# ## ASSIGN ROLE ASSIGNMENT FOR ADB_SVC_PN TO Keyvault

resource "azurerm_role_assignment" "adb_to_kv_access" {
  scope                = data.azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.object_id
  depends_on           = [data.azurerm_key_vault.key_vault, module.databricks]
}

# ## ASSIGN ROLE ASSIGNMENT FOR ADB_SVC_PN TO ADX

resource "azurerm_kusto_database_principal_assignment" "adb_to_kusto_access" {
  name                = "ADBKustoPrincipalAssignmentUser"
  resource_group_name = data.azurerm_resource_group.resource_group_name.name
  cluster_name        = data.azurerm_kusto_cluster.kusto_cluster.name
  database_name       = data.azurerm_kusto_database.adb_kusto_database.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  principal_id        = var.object_id
  principal_type      = "App"
  role                = "User"
  // depends_on          = [data.azurerm_kusto_database]
}

resource "azurerm_kusto_database_principal_assignment" "adb_to_kusto_access_ingestor" {
  name                = "ADBKustoPrincipalAssignmentIngestor"
  resource_group_name = data.azurerm_resource_group.resource_group_name.name
  cluster_name        = data.azurerm_kusto_cluster.kusto_cluster.name
  database_name       = data.azurerm_kusto_database.adb_kusto_database.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  principal_id        = var.object_id
  principal_type      = "App"
  role                = "Ingestor"
  // depends_on          = [module.data_explorer_database]
}