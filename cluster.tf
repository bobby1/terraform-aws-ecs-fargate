resource "aws_ecs_cluster" "devopsuncut-ecs-cluster" {
  name = "${var.business_divsion}-${var.environment}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
