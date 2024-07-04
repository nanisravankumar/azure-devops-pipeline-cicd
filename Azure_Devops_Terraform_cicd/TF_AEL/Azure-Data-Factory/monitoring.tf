resource "azurerm_monitor_metric_alert" "adf_metric_alert" {
  name                = "adf-metricalert"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [module.data_factory.id]
  auto_mitigate       = "false"
  description         = "ADF Monitoring alert"

  criteria {
    metric_namespace = "Microsoft.DataFactory/factories"
    metric_name      = "ActivityCancelledRuns"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 2
  }
  criteria {
    metric_namespace = "Microsoft.DataFactory/factories"
    metric_name      = "ActivityFailedRuns"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 2
  }
  criteria {
    metric_namespace = "Microsoft.DataFactory/factories"
    metric_name      = "ActivitySucceededRuns"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 2
  }
  criteria {
    metric_namespace = "Microsoft.DataFactory/factories"
    metric_name      = "PipelineFailedRuns"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 0
  }
  criteria {
    metric_namespace = "Microsoft.DataFactory/factories"
    metric_name      = "TriggerFailedRuns"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 0
  }
  action {
    action_group_id = data.azurerm_monitor_action_group.email_alert.id
  }

  depends_on = [
    azurerm_monitor_metric_alert.adf_metric_alert,
    module.data_factory
  ]
}

resource "azurerm_monitor_activity_log_alert" "adf_activity_log" {
  name                = "adf-activitylogalert"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [module.data_factory.id]
  description         = "This alert will monitor a specific adf updates."

  criteria {
    resource_id    = module.data_factory.id
    //operation_name = "Microsoft.Storage/storageAccounts/write"
    category       = "ResourceHealth"

    resource_health {
      current = ["Unavailable", "Degraded"]
      previous = ["Available"]
    }
  }

  action {
    action_group_id = data.azurerm_monitor_action_group.email_alert.id
  }

  depends_on = [
    azurerm_monitor_activity_log_alert.adf_activity_log,
    module.data_factory
  ]
}
