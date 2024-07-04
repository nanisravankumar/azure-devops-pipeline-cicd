output "databricks_azure_workspace_resource_id" {
  value = azurerm_databricks_workspace.workspace.id
}

output "workspace_url" {
  value = "https://${azurerm_databricks_workspace.workspace.workspace_url}/"
}

# output "module_cluster_id" {
#   value = module.auto_scaling_cluster_example.cluster_id
# }

# output "principal_id" {
#   value = azurerm_databricks_workspace.workspace.managed_disk_identity
# }
