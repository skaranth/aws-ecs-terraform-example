terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}


module "vpc" {
  source = "../shared/vpc"
  env = var.env
  start_cidr = var.start_cidr
}

module "cert" {
  source = "../shared/cert"
  env = var.env
  domain = var.domain
}

module "todo-backend" {
  source = "../shared/ecr"
  service_name = "todo-backend"
  env = var.env
}
