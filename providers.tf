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
  backend "s3" {
    bucket = "terraform-morpheus-int"
    key    = "terraform/main.tfstate"
    region = "eu-north-1"
    #####Morpheus_only
    access_key = var.access_key
    secret_key = var.secret_key
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
  access_token = var.morpheus_access_token

}
