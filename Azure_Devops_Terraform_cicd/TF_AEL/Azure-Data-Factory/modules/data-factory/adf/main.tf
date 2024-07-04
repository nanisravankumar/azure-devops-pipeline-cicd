terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }

  required_version = ">= 0.14.9"
}

resource "azurerm_data_factory" "adf_ws" {
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  managed_virtual_network_enabled = true
  public_network_enabled          = var.public_network_access

  identity {
    type = "SystemAssigned"
  }

  // Lifecycle block required if global_parameters and vsts_configuration needs to be ignored.
  lifecycle {
    ignore_changes = all
  }
}


# Grant Data Factory contributor role to the system-assigned identity
resource "azurerm_role_assignment" "role_assignment_adf" {
  scope                = azurerm_data_factory.adf_ws.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_data_factory.adf_ws.identity[0].principal_id

  depends_on = [azurerm_data_factory.adf_ws]
}

# # Sleep is needed to wait for role assignment to propagate
resource "time_sleep" "role_assignment_sleep_adf" {
  create_duration = "60s"

  triggers = {
    role_assignment = azurerm_role_assignment.role_assignment_adf.id
  }
}

// resource "azurerm_data_factory_linked_service_key_vault" "data_key_vault" {
//   name            = "Is_AKV"
//   data_factory_id = azurerm_data_factory.adf_ws.id
//   key_vault_id    = data.azurerm_key_vault.key_vault.id
//   integration_runtime_name = "adf-shir-adani"
// }

// resource "azurerm_data_factory_linked_service_postgresql" "data_postgres" {
//   name              = "Is_postgres"
//   data_factory_id   = azurerm_data_factory.example.id
//   connection_string = "Host=example;Port=5432;Database=example;UID=example;EncryptionMethod=0;Password=example"
// }

// resource "azurerm_key_vault_secret" "sec-client-id-spn" {
//   name         = "sec-client-id-spn"
//   key_vault_id = var.keyvault_id
//   value        = var.value1
// }

// resource "azurerm_key_vault_secret" "sec-client-secret-spn" {
//   name         = "sec-client-secret-spn"
//   key_vault_id = var.keyvault_id
//   value        = var.value2
// }

resource "azurerm_key_vault_secret" "sec-client-id-spn" {
  name         = "sec-client-id-spn"
  key_vault_id = var.keyvault_id
  value        = var.sec-client-id-spn
}

resource "azurerm_key_vault_secret" "sec-client-secret-spn" {
  name         = "sec-client-secret-spn"
  key_vault_id = var.keyvault_id
  value        = var.sec-client-secret-spn
}

# # Private DNS & Private Endpoint 

module "data_factory_private_endpoint" {
  source                         = "../../private_endpoint"
  name                           = "${azurerm_data_factory.adf_ws.name}Df-PE"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  subnet_id                      = var.pe_subnet_id
  tags                           = var.tags
  private_connection_resource_id = azurerm_data_factory.adf_ws.id
  is_manual_connection           = false
  subresource_name               = "dataFactory"
  
}

module "data_factory_portal_private_endpoint" {
  source                         = "../../private_endpoint"
  name                           = "${azurerm_data_factory.adf_ws.name}Df-Portal"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  subnet_id                      = var.pe_subnet_id
  tags                           = var.tags
  private_connection_resource_id = azurerm_data_factory.adf_ws.id
  is_manual_connection           = false
  subresource_name               = "portal"
 
}


