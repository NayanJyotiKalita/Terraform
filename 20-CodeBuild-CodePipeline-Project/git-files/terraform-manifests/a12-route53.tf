variable "dns_name" {
  description = "DNS Name for multiple environment"
  type = string
}

resource "aws_route53_record" "app_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = var.dns_name
  type    = "A"
  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }  
}