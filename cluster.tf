resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.business_division}-${var.environment}-ecs-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}