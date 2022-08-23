variable "tfc_organization" {
  type        = string
  description = "TFC Organization for remote state of infrastructure"
}

data "terraform_remote_state" "infrastructure" {
  backend = "remote"

  config = {
    organization = var.tfc_organization
    workspaces = {
      name = "hashicorp-stack-demoapp-infrastructure"
    }
  }
}

variable "operations_team" {
  type = set(string)
}

variable "products_team" {
  type = set(string)
}

variable "leadership_team" {
  type = set(string)
}

variable "products_frontend_address" {
  type    = string
  default = ""
}

variable "vault_private_address" {
  type    = string
  default = ""
}

variable "consul_private_address" {
  type    = string
  default = ""
}

data "aws_instances" "eks" {
  instance_tags = {
    "eks:cluster-name" = local.eks_cluster_name
  }
}

locals {
  eks_cluster_name                 = data.terraform_remote_state.infrastructure.outputs.eks_cluster_name
  region                           = data.terraform_remote_state.infrastructure.outputs.region
  url                              = data.terraform_remote_state.infrastructure.outputs.boundary_endpoint
  kms_recovery_key_id              = data.terraform_remote_state.infrastructure.outputs.boundary_kms_recovery_key_id
  eks_target_ips                   = toset(data.aws_instances.eks.private_ips)
  products_database_target_address = data.terraform_remote_state.infrastructure.outputs.product_database_address
  consul_private_address           = replace(data.terraform_remote_state.infrastructure.outputs.hcp_consul_private_address, "https://", "")
  vault_private_address            = replace(replace(data.terraform_remote_state.infrastructure.outputs.hcp_vault_private_address, "https://", ""), ":8200", "")
}