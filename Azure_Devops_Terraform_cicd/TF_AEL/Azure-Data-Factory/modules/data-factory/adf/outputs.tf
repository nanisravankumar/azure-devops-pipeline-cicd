output "name" {
  description = "Specifies the name of the Data Factory"
  value       = azurerm_data_factory.adf_ws.name
}

output "id" {
  value = azurerm_data_factory.adf_ws.id
}

output "principal_id" {
  value = azurerm_data_factory.adf_ws.identity[0].principal_id
}
