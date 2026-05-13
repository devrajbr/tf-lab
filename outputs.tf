output "app_instance_ids" {
  value = module.app_stack.instance_ids
}

output "app_config_files" {
  value = module.app_stack.config_files
}

output "suggested_storage_name" {
  value = module.naming.storage_account.name_unique
}

output "resource_group_name" {
  description = "Compliant Azure resource group name"
  value       = module.naming.resource_group.name
}

output "storage_account_name" {
  description = "Storage account name (max 24 chars, lowercase)"
  value       = module.naming.storage_account.name_unique
}

output "key_vault_name" {
  description = "Key vault name"
  value       = module.naming.key_vault.name
}

output "virtual_machine_name" {
  description = "Virtual machine name"
  value       = module.naming.virtual_machine.name
}

output "app_service_name" {
  description = "App service name"
  value       = module.naming.app_service.name
}