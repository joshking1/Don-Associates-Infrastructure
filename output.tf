output "public_ip" {
  value = aws_instance.web_server.public_ip
}

output "load_balancer_dns" {
  value = aws_lb.app_lb.dns_name
}
