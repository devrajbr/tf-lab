resource "random_id" "app_id" {
  count       = var.instance_count
  byte_length = 4
}

resource "local_file" "app_config" {
  count    = var.instance_count
  filename = "${path.module}/output-${var.environment}-${count.index}.conf"
  content  = <<-EOF
    app_name     = ${var.app_name}-${count.index}
    environment  = ${var.environment}
    instance_id  = ${random_id.app_id[count.index].hex}
    deployed_at  = ${timestamp()}
  EOF
}
