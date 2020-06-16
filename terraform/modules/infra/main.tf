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


module "alb" {
  source = "../shared/alb"
  cert_arn = data.terraform_remote_state.setup.cert_arn
  domain = var.domain
  env = var.env
  egrees_cidr = data.terraform_remote_state.setup.vpc_cidr_block
  subnets = data.terraform_remote_state.setup.public_subnets
  vpc_id = data.terraform_remote_state.setup.vpc_id

}



