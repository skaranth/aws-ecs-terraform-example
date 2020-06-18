terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}

data "terraform_remote_state" "setup" {
  backend = "s3"
  config = {
    bucket = "${var.product_code}-${var.env}-setup"
    key    = "setup/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = "${var.product_code}-${var.env}-infra"
    key    = "infra/terraform.tfstate"
    region = var.aws_region
  }
}

module "todo-backend" {
  source = "../shared/microservice"
  app_port = 8080
  ecr_repo = data.terraform_remote_state.setup.outputs.repo_urls["todo-backend"]
  env = var.env
  product_code = var.product_code
  product_version = var.product_version
  size = var.env_size
  service_name = "todo-backend"
  vpc_id = data.terraform_remote_state.setup.outputs.vpc_id
  alb_id = data.terraform_remote_state.infra.outputs.alb_id
  alb_dns_name = data.terraform_remote_state.infra.outputs.alb_dns_name
  alb_listener_arn = data.terraform_remote_state.infra.outputs.alb_https_listener_arn
  domain = var.domain
}
