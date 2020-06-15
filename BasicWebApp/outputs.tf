output "public_ip_of_web_server" {
    value = aws_instance.web_server.public_ip
}