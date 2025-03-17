output "load_balancer_ip" {
  value = aws_lb.cluster_lb.dns_name
}