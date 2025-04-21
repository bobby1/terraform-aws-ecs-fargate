resource "aws_security_group" "lb" {
  description = "controls access to the Application Load Balancer (ALB)"
  name        = "${var.business_division}-${var.environment}-lb-sg"
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "Cidr Blocks and ports for Ingress security"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = var.ingress_cidr_blocks[var.environment]
  }
  egress {
    description = "Cidr Blocks and ports for Egress security"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = var.egress_cidr_blocks[var.environment]
  }
}
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.business_division}-${var.environment}-ecs-tasks-sg"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.main.id
  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lb.id]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}