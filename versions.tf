terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket       = "terraform-backend-bucket-n7j3h6tky57u"
    key          = "aitt"
    region       = "eu-west-3"
    use_lockfile = true
  }
}

provider "aws" {
  default_tags {
    tags = {
      Project    = var.project
      Env        = var.env
      CreatedBy  = "terraform"
      Owner      = var.owner
      CostCenter = var.cost_center
    }
  }
}
