resource "azurerm_data_factory_integration_runtime_self_hosted" "adl_adf_shir" {
  lifecycle {
    ignore_changes = all
  }
  name            = var.name
  data_factory_id = var.data_factory_id
}