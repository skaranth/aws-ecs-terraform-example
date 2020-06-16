locals {
  name = "${var.env}-public"

}

data "aws_route53_zone" "target" {
  name         = var.domain
}


resource "aws_security_group" "sg-public-alb" {
  name = "sg-${var.name}"
  description = "Public Application ALB SG"
  vpc_id = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = var.white_list
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = var.white_list
    self = true
  }

  egress {
    from_port = 8080
    to_port = 8080
    protocol = "TCP"
    cidr_blocks = [
      "${var.egress_cidr}"]
    self = true
  }

  tags = {
    Name = "sg-${var.name}"
    Terraform = "true"
    Environment = var.env
  }
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name = local.name

  load_balancer_type = "application"

  vpc_id = var.vpc_id
  subnets = var.subnets
  security_groups = [
    aws_security_group.sg-public-alb.id]

  https_listeners = [
    {
      port = 443
      protocol = "HTTPS"
      certificate_arn = var.cert_arn
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port = 80
      protocol = "HTTP"
      action_type = "redirect"
      redirect = {
        port = "443"
        protocol = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  target_groups = [
    {
      name_prefix = "${local.name}-dummytg-"
      backend_protocol = "HTTPS"
      backend_port = 80
    }
  ]
  tags = {
    Terraform = "true"
    Environment = var.env
  }
}


resource "aws_route53_record" "record" {
  name = var.env
  zone_id = data.aws_route53_zone.zone_id
  type = "CNAME"
  ttl = "300"
  records = [
    "${module.alb.this_lb_dns_name}"]
  tags = {
    Terraform = "true"
    Environment = var.env
  }

}
