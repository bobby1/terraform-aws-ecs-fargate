resource "aws_lb" "cluster_lb" {
  name               = "${var.business_division}-${var.environment}-cluster-alb"
  subnets            = aws_subnet.public[*].id
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  tags = {
    Application = "${var.business_division}-${var.environment}-webpage"
  }
}
resource "aws_lb_listener" "https_forward" {
  load_balancer_arn = aws_lb.cluster_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-fargate-TG.arn
  }
}
resource "aws_lb_target_group" "ecs-fargate-TG" {
  name        = "${var.business_division}-${var.environment}-ecs-fargate-TG"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "90"
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = "20"
    path                = "/"
    unhealthy_threshold = "2"
  }
}