terraform {
  required_version = ">= 1.3.4"
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = ">= 4.37.0"
    }
  }
}