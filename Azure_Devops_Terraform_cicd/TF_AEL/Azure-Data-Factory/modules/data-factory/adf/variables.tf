variable "resource_group_name" {
  description = "The name of the resource group in which to create the blob storage."
  type        = string
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists."
  type        = string
}

variable "name" {
  description = "(Required) Specifies the name of the Data Factory"
  type        = string
}

variable "public_network_access" {
  description = "(Optional) Whether public network access is allowed for this Data Factory. Defaults to true"
  type        = bool
  default     = true
}


variable "subscription_id" {}
variable "vnet_name" {}
variable "pe_subnet_id" {}
variable "vnet_rg_name" {}
variable "tags" {}
variable "key_vault_name" {}
variable "sec-client-secret-spn" {}
variable "sec-client-id-spn" {}
variable "keyvault_id" {}
