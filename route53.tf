resource "aws_route53_zone" "wenorg" {
  name = "${var.business_division}-${var.environment}-wen.org"
}
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.wenorg.zone_id
  name    = "${var.business_division}-${var.environment}-wen.org"
  type    = "A"
  alias {
    name                   = aws_lb.cluster_lb.dns_name
    zone_id                = aws_lb.cluster_lb.zone_id
    evaluate_target_health = true
  }
}