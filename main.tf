provider "azurerm" {
  features {}
  subscription_id = "abd34832-7708-43f9-a480-e3b7a87b41d7"
}

data "azurerm_user_assigned_identity" "vault_identities" {
  for_each = {
    for vault_key, vault in var.recovery_vault_config :
    vault_key => {
      identities          = try(vault.managed_identities.user_assigned_identity_names, [])
      resource_group_name = vault.resource_group_name
    } if try(length(vault.managed_identities.user_assigned_identity_names), 0) > 0
  }

  name                = each.value.identities[0] # Assuming only one user-assigned identity per vault
  resource_group_name = each.value.resource_group_name
}
resource "azurerm_user_assigned_identity" "vault_identity" {
  name                = "vault-identity"
  resource_group_name = var.recovery_vault_config.resource_group_name
  location            = var.recovery_vault_config.location
  tags                = var.recovery_vault_config.tags
}

module "azure_recovery_services_vault" {
  source = "git::https://github.com/Azure/terraform-azurerm-avm-res-recoveryservices-vault.git?ref=2794a299f935ed4999685a92fae7523b91b72267"
  # version = "0.1.1"

  for_each = toset(var.name)

  name                                           = each.key
  location                                       = var.recovery_vault_config.location
  resource_group_name                            = var.recovery_vault_config.resource_group_name
  cross_region_restore_enabled                   = var.recovery_vault_config.cross_region_restore_enabled
  alerts_for_all_job_failures_enabled            = var.recovery_vault_config.alerts_for_all_job_failures_enabled
  alerts_for_critical_operation_failures_enabled = var.recovery_vault_config.alerts_for_critical_operation_failures_enabled
  classic_vmware_replication_enabled             = var.recovery_vault_config.classic_vmware_replication_enabled
  public_network_access_enabled                  = var.recovery_vault_config.public_network_access_enabled
  storage_mode_type                              = var.recovery_vault_config.storage_mode_type
  sku                                            = var.recovery_vault_config.sku
  managed_identities = {
    system_assigned            = var.recovery_vault_config.managed_identities.system_assigned
    user_assigned_resource_ids = [azurerm_user_assigned_identity.vault_identity.id]
  } # var.recovery_vault_config.managed_identities
  tags                     = var.recovery_vault_config.tags
  workload_backup_policy   = var.recovery_vault_config.workload_backup_policy
  vm_backup_policy         = var.recovery_vault_config.vm_backup_policy
  file_share_backup_policy = var.recovery_vault_config.file_share_backup_policy
}
