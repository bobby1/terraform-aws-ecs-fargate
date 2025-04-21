resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${var.business_division}-${var.environment}-ecs-cluster/${var.environment}-${var.service}-ecs-service"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}
### Policy for CPU  and memory utilization autoscaling
resource "aws_appautoscaling_policy" "ecs_cpu_policy" {
  name               = "${var.environment}-${var.service}-srv-cpu-scale"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace
  target_tracking_scaling_policy_configuration {
    target_value = 85.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}
resource "aws_appautoscaling_policy" "ecs_memory_policy" {
  name               = "${var.environment}-${var.service}-srv-memory-scale"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace
  target_tracking_scaling_policy_configuration {
    target_value = 85.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}
### Scheduled action to start and stop the service on dev and sta
resource "aws_appautoscaling_scheduled_action" "start_service" {
  name               = "${var.environment}-${var.service}-srv-start"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  schedule           = "cron(00 06 ? * MON-FRI *)"
  service_namespace  = "ecs"
  timezone           = "America/Los_Angeles"
  scalable_target_action {
    min_capacity = 1
    max_capacity = 2
  }
}
resource "aws_appautoscaling_scheduled_action" "stop_service" {
  count              = var.environment == "prd" ? 0 : 1
  name               = "${var.environment}-${var.service}-srv-stop"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  schedule           = "cron(00 17 ? * MON-FRI *)"
  service_namespace  = "ecs"
  timezone           = "America/Los_Angeles"
  scalable_target_action {
    min_capacity = 0
    max_capacity = 0
  }
}