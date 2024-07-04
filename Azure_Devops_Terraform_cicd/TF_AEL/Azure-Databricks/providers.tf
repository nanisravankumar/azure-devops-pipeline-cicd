terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.60"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.9.0"
    }
    databricks = {
      source = "databricks/databricks"
    }
  }

}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "databricks" {
  host                        = module.databricks.workspace_url
  azure_workspace_resource_id = module.databricks.databricks_azure_workspace_resource_id
}

resource "databricks_token" "pat" {
  comment  = "Terraform Provisioning"
  // 100 day token
  // lifetime_seconds = 8640000
}

resource "azurerm_key_vault_secret" "databricks_PAT" {
  name         = "adani-databricks-pat"
  key_vault_id = data.azurerm_key_vault.key_vault.id
  value        = databricks_token.pat.token_value
}

