module "data_factory" {
  source                = "./modules/data-factory/adf"
  name                  = var.data_factory_name
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  public_network_access = var.public_network_access
  subscription_id       = data.azurerm_client_config.current.subscription_id
  vnet_rg_name          = var.vnet_rg_name
  vnet_name             = var.vnet_name
  pe_subnet_id          = data.azurerm_subnet.endpoint_subnet.id
  tags                  = var.tags
  key_vault_name        = data.azurerm_key_vault.key_vault.name
  keyvault_id          = data.azurerm_key_vault.key_vault.id
  sec-client-id-spn     = var.sec-client-id-spn
  sec-client-secret-spn = var.sec-client-secret-spn
}


module "data_factory_self_hosted_integration_runtime" {
  source                   = "./modules/data-factory/integration-runtime"
  name                     = var.df_integration_runtime
  data_factory_id          = module.data_factory.id
}

