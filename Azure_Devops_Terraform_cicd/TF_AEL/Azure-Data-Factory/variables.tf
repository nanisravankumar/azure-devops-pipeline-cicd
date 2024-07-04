variable "tags" {
  default = {
    Application = "AdaniIC",
    BU = "IC",
    Classification = "Silver",
    Criticality = "Low",
    Env = "QA",
    Owner = "Parin Shah",
    Role = "Application",
    IAC = "Terraform"
  }
  type    = map(string)
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_rg_name" {
  type = string
}

variable "pe_subnet_name" {
  type = string
}


variable "data_factory_name" {
  type = string
}

variable "df_integration_runtime" {}
variable "public_network_access" {}
variable "default_action" {}
variable "is_hns_enabled" {}
variable "enable_https_traffic_only" {}
variable "allow_nested_items_to_be_public" {}
variable "replication_type" {}
variable "account_tier" {}
variable "account_kind" {}
variable "key_vault_name" {}
variable "storage_account_name" {}
variable "kusto_cluster_name" {}
variable "kusto_database_name" {}
variable "subscription_id" {}
variable "databricks_name" {}
variable "monitor_action_group_name" {}
variable "sec-client-id-spn" {}
variable "sec-client-secret-spn" {}
