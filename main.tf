terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

# Calling your internal golden module
module "app_stack" {
  source = "./modules/app-stack"

  environment    = var.environment
  app_name       = var.app_name
  instance_count = 2
}

# Calling a PUBLIC Terraform Registry module
# This is a real module from registry.terraform.io
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.4"
  suffix  = [var.environment]
}

resource "local_file" "azure_config" {
  filename = "${path.module}/${module.naming.resource_group.name}.conf"
  content  = <<-EOF
    resource_group   = ${module.naming.resource_group.name}
    storage_account  = ${module.naming.storage_account.name_unique}
    key_vault        = ${module.naming.key_vault.name}
    virtual_machine  = ${module.naming.virtual_machine.name}
    app_service      = ${module.naming.app_service.name}
    environment      = ${var.environment}
  EOF
}

provider "aws" {
  region = "us-east-1"

  # This tells Terraform not to call real AWS APIs
  # Infracost only needs the plan JSON, not live credentials
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  access_key = "mock_access_key"
  secret_key = "mock_secret_key"
}

# Add to main.tf - simulates a real AWS resource for Infracost to price
# (no AWS credentials needed - Infracost reads the plan, not live infra)

resource "aws_instance" "demo" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.medium"

  root_block_device {
    volume_type = "gp3"
    volume_size = 6
  }

  tags = {
    #Environment = var.environment   # ← commented out to test policy
    Team       = "platform"
    CostCentre = "eng-001"
    Owner      = "devraj"
  }
}