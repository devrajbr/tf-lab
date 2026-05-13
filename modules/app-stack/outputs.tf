output "instance_ids" {
  description = "Generated instance IDs"
  value       = [for r in random_id.app_id : r.hex]
}

output "config_files" {
  description = "Paths to generated config files"
  value       = [for f in local_file.app_config : f.filename]
}