output "lb_security_group_id" {
  value = aws_security_group.lb_security_group.id
}

output "alb_dns_name" {
 value = aws_lb.ingress.dns_name  
}
