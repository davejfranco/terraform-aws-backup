# AWS main configuration
provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "drp"
  region = var.drp_region
}