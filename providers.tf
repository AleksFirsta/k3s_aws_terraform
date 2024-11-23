terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.76.0"
    }
    morpheus = {
      source  = "gomorpheus/morpheus"
      version = "0.10.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
  default_tags {
    tags = {
      Environment = "Morpheus"
      Project     = "Morpheus k3s cluster"
      Owner       = "Grigorenko"
    }
  }
}
provider "morpheus" {
  url          = var.morpheus_url
  access_token = var.access_token

}