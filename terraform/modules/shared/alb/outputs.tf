output "alb_id" {
  value = module.alb.this_lb_id
}

output "alb_dns_name" {
  value = module.alb.this_lb_dns_name
}

output "alb_https_listener_arn"{
  value = module.alb.https_listener_arns[0]
}

