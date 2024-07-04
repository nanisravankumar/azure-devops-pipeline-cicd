# variable "node_type_id" {
#   type = string
# }

variable "autotermination_minutes" {
  type = number
}

variable "cluster_name" {}
variable "node_type_id" {}
variable "driver_node_type_id" {}
variable "spark_version" {}
variable "max_workers" {}
variable "min_workers" {}

variable "keyvault_id" {}
variable "keuvault_uri" {}
# variable "container_id" {}

# variable "databricks_client_id" {}
# variable "databricks_client_secret" {}
# variable "storage_account_name" {}
# variable "tenant_id" {}
