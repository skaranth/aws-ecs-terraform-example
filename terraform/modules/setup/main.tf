terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}

module "todo-backend" {
  source = "../shared/ecr"
  service_name = "todo-backend"
}
