resource "aws_ecs_service" "service_name" {
  name            = "${var.environment}-${var.service}-ecs-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = var.app_count[var.environment]
  launch_type     = "FARGATE" ##
  network_configuration {
    security_groups = [aws_security_group.ecs_tasks.id]
    subnets         = aws_subnet.private.*.id
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs-fargate-TG.arn
    container_name   = "${var.business_division}-${var.environment}-webpage"
    container_port   = 80
  }
  depends_on = [aws_lb_listener.https_forward]
}