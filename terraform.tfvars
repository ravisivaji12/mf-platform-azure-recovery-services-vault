recovery_vault_config = {
  name                                           = "recovery-vault-prod"
  location                                       = "East US"
  resource_group_name                            = "rg-prod-vault"
  cross_region_restore_enabled                   = false
  alerts_for_all_job_failures_enabled            = true
  alerts_for_critical_operation_failures_enabled = true
  classic_vmware_replication_enabled             = false
  public_network_access_enabled                  = true
  storage_mode_type                              = "GeoRedundant"
  sku                                            = "RS0"
  managed_identities = {
    system_assigned            = true
    user_assigned_resource_ids = ["/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.ManagedIdentity/userAssignedIdentities/identity1"]
  }
  tags = {
    env   = "Prod"
    owner = "ABREG0"
    dept  = "IT"
  }

  workload_backup_policy = {
    "pol-rsv-SAPh-vault-002" = {
      name          = "pol-rsv-SAPh-vault-01"
      workload_type = "SAPHanaDatabase"
      settings = {
        time_zone           = "Pacific Standard Time"
        compression_enabled = false
      }
      backup_frequency = "Weekly"
      protection_policy = {
        log = {
          policy_type           = "Log"
          retention_daily_count = 15
          backup = {
            frequency_in_minutes = 15
            time                 = "22:00"
            weekdays             = ["Saturday"]
          }
        }
        full = {
          policy_type           = "Full"
          retention_daily_count = 15
          backup = {
            time     = "22:00"
            weekdays = ["Saturday"]
          }
          retention_weekly = {
            count    = 10
            weekdays = ["Saturday"]
          }
          retention_monthly = {
            count     = 10
            weekdays  = ["Saturday"]
            weeks     = ["First", "Third"]
            monthdays = [3, 10, 20]
          }
          retention_yearly = {
            count     = 10
            months    = ["January", "June", "October", "March"]
            weekdays  = ["Saturday"]
            weeks     = ["First", "Second", "Third"]
            monthdays = [3, 10, 20]
          }
        }
        differential = {
          policy_type           = "Differential"
          retention_daily_count = 15
          backup = {
            time     = "22:00"
            weekdays = ["Wednesday", "Friday"]
          }
        }
      }
    }
  }

  vm_backup_policy = {
    pol-rsv-vm-vault-001 = {
      name                           = "pol-rsv-vm-vault-001"
      timezone                       = "Pacific Standard Time"
      instant_restore_retention_days = 5
      policy_type                    = "V2"
      frequency                      = "Weekly"
      instant_restore_resource_group = {
        ps = {
          prefix = "prefix-"
          suffix = null
        }
      }
      backup = {
        time          = "22:00"
        hour_interval = 6
        hour_duration = 12
        weekdays      = ["Tuesday", "Saturday"]
      }
      retention_daily = 7
      retention_weekly = {
        count    = 7
        weekdays = ["Tuesday", "Saturday"]
      }
      retention_monthly = {
        count             = 5
        weekdays          = ["Tuesday", "Saturday"]
        weeks             = ["First", "Third"]
        days              = [3, 10, 20]
        include_last_days = false
      }
      retention_yearly = {
        count             = 5
        months            = ["January", "June"]
        weekdays          = ["Tuesday", "Saturday"]
        weeks             = ["First", "Third"]
        days              = [3, 10, 20]
        include_last_days = false
      }
    }
  }

  file_share_backup_policy = {
    pol-rsv-fileshare-vault-001 = {
      name     = "pol-rsv-fileshare-vault-001"
      timezone = "Pacific Standard Time"
      frequency = "Daily"
      backup = {
        time = "22:00"
        hourly = {
          interval        = 6
          start_time      = "13:00"
          window_duration = "6"
        }
      }
      retention_daily = 1
      retention_weekly = {
        count    = 7
        weekdays = ["Tuesday", "Saturday"]
      }
      retention_monthly = {
        count             = 5
        days              = [3, 10, 20]
        include_last_days = false
      }
      retention_yearly = {
        count    = 5
        months   = ["January", "June"]
        weekdays = ["Tuesday", "Saturday"]
        weeks    = ["First", "Third"]
      }
    }
  }
}
