variable "tags" {
  default = {
    Application = "AdaniIC",
    BU = "IC",
    Classification = "Silver",
    Criticality = "Low",
    Env = "DEV",
    Owner = "Parin Shah",
    Role = "Application",
    IAC = "Terraform"
  }
  type    = map(string)
}

variable "resource_group_name" {
  type = string
}

# variable "location" {
#   type = string
# }

variable "vnet_name" {
  type = string
}

variable "vnet_rg_name" {
  type = string
}

variable "pe_subnet_name" {
  type = string
}

// variable "postgres_subnet_name" {
//   type = string
// }

variable "adbpub_subnet_name" {
  type = string
}

variable "adbpri_subnet_name" {
  type = string
}

variable "key_vault_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

// variable "eventhub_namespace" {
//   type = string
// }

// variable "data_factory_name" {
//   type = string
// }

// variable "data_explorer_name" {
//   type = string
// }

// variable "postgresql_name" {
//   type = string
// }

variable "databricks_name" {
  type = string
}
variable "kusto_database_name" {}

variable "object_id" {}
variable "application_id" {}
variable "kusto_cluster_name" {}
variable "subscription_id" {}
variable "cluster_name" {}
variable "node_type_id" {}
variable "driver_node_type_id" {}
variable "spark_version" {}
variable "autotermination_minutes" {}
variable "min_workers" {}
variable "max_workers" {}
variable "sku" {}
variable "private_subnet_network_security_group_association_id" {}
variable "public_subnet_network_security_group_association_id" {}

