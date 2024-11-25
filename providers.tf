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
    bucket     = "terraform-morpheus-int"
    key        = "terraform/main.tfstate"
    region     = "eu-north-1"
    access_key = "<%=cypher.read('secret/awsautomation').tokenize('|')[0]%>"
    secret_key = "<%=cypher.read('secret/awsautomation').tokenize('|')[1]%>"
  }
}

provider "aws" {
  region = var.aws_region
  # access_key = var.access_key
  # secret_key = var.secret_key
  access_key = "<%=cypher.read('secret/awsautomation').tokenize('|')[0]%>"
  secret_key = "<%=cypher.read('secret/awsautomation').tokenize('|')[1]%>"
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
  access_token = "<%=cypher.read('secret/awsautomation').tokenize('|')[2]%>"

}
