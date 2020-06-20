output "public_dns_name_of_application_load_balancer" {
    value = aws_alb.alb.dns_name
}