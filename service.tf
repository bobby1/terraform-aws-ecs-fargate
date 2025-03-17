resource "aws_ecs_service" "service_name" {
  name            = "${var.environment}-${var.service}-ecs-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = var.app_count[var.environment]
  # launch_type     = "FARGATE"
  launch_type = "EC2"
  network_configuration {
    security_groups = [aws_security_group.ecs_tasks.id]
    subnets         = aws_subnet.private.*.id
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs-fargate-TG.arn
    # container_name   = "devops-webpage"
    # container_name = "${var.environment}-${var.service}-LB"
    # container_name = "${var.business_division}-${var.environment}-cluster-alb"
    container_name = "${var.business_division}-${var.environment}-webpage"
    container_port = 80
  }
  depends_on = [aws_lb_listener.https_forward]
}