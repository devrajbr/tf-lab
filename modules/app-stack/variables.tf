variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "instance_count" {
  description = "Number of app instances"
  type        = number
  default     = 1
}