locals{
  dns = "${var.env}.${var.domain}"
}


resource "aws_acm_certificate" "cert" {
  domain_name = local.dns
  validation_method = "DNS"


  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Terraform = "true"
    Environment = var.env
  }
}
