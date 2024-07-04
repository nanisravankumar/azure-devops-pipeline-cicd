terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    databricks = {
      source = "databricks/databricks"
    }
  }
  required_version = ">= 0.14.9"
}

data "azurerm_client_config" "current" {}

data "databricks_current_user" "me" {
}

resource "databricks_cluster" "shared_autoscaling" {
  cluster_name            = var.cluster_name
  spark_version           = var.spark_version
  node_type_id            = var.node_type_id
  driver_node_type_id     = var.driver_node_type_id #"Standard_E4as_v4"
  autotermination_minutes = var.autotermination_minutes
  autoscale {
    min_workers = var.min_workers
    max_workers = var.max_workers
  }
}

resource "databricks_secret_scope" "kv" {
  name = "azurekeyvault_adb_secret_scope" #changed to scope

  keyvault_metadata {
    resource_id = var.keyvault_id
    dns_name    = var.keuvault_uri
  }
}


resource "databricks_library" "iot_hub" {
  cluster_id = databricks_cluster.shared_autoscaling.id
  pypi {
    package = "azure-iot-hub"
    // repo can also be specified here
  }
}

resource "databricks_library" "iot_device" {
  cluster_id = databricks_cluster.shared_autoscaling.id
  pypi {
    package = "azure-iot-device"
    // repo can also be specified here
  }
}

resource "databricks_library" "open_py" {
  cluster_id = databricks_cluster.shared_autoscaling.id
  pypi {
    package = "openpyxl"
    // repo can also be specified here
  }
}

resource "databricks_library" "psy_cop" {
  cluster_id = databricks_cluster.shared_autoscaling.id
  pypi {
    package = "psycopg2"
    // repo can also be specified here
  }
}


# resource "databricks_dbfs_file" "eventhub_spark" {
#   source = "./modules/databricks/packages/azure-eventhubs-spark_2.12-2.3.21.jar"
#   path   = "/FileStore/azure-eventhubs-spark_2.12-2.3.21.jar"
# }

# resource "databricks_library" "eventhub_spark" {
#   cluster_id = databricks_cluster.shared_autoscaling.id
#   jar        = databricks_dbfs_file.eventhub_spark.dbfs_path
#   depends_on = [databricks_dbfs_file.eventhub_spark]
# }

# resource "databricks_dbfs_file" "kusto_spark" {
#   source = "./modules/databricks/packages/kusto-spark_3.0_2.12-3.1.15.jar"
#   path   = "/FileStore/kusto-spark_3.0_2.12-3.1.15.jar"
# }

# resource "databricks_library" "kusto_spark" {
#   cluster_id = databricks_cluster.shared_autoscaling.id
#   jar        = databricks_dbfs_file.kusto_spark.dbfs_path
#   depends_on = [databricks_dbfs_file.kusto_spark]
# }



