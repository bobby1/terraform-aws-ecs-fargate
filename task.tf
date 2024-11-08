# resource "aws_ecs_task_definition" "devopsuncut_td" {
resource "aws_ecs_task_definition" "task_definition" {
  # family                   = "${var.business_divsion}-${var.environment}-webpage"
  family                   = "devops-webpage"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 2048
  memory                   = 4096

  container_definitions = <<DEFINITION
[
  {
    "image": "httpd:latest",
    "cpu": 2048,
    "memory": 4096,
    "name": "devops-webpage",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION
}
