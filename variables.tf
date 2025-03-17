# General project information
# Business Division
variable "business_division" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
}
# AWS Region
variable "region" {
  description = "Region in which AWS Resources to be created"
  type        = string
}
variable "service" {
  description = "Service name"
  type        = string
}
variable "app_count" {
  description = "Number of instances to provision."
  type        = map(number)
  default = {
    dev = 2
    stg = 4
    prd = 6
  }
}
variable "egress_cidr_blocks" {
  description = "CIDR blocks to allow in the security group"
  type        = map(list(string))
  default = {
    dev = ["0.0.0.0/0", ]
    stg = ["0.0.0.0/0", ]
    prd = ["0.0.0.0/0", ]
  }
}
variable "ingress_cidr_blocks" {
  description = "CIDR blocks to allow in the security group"
  type        = map(list(string))
  default = {
    ### IP for individual developer's remote address, 67.174.209.57/32 is an access IP address  ### DEBUG
    dev = ["98.207.22.120/32", "67.180.167.206/32", "75.36.1.193/32"]
    # dev = ["0.0.0.0/0",]
    ### example IPs for a company's testing evironement  ### DEBUG
    stg = ["98.207.22.120/32", "172.25.176.0/24", "172.31.0.0/16", ]
    prd = ["0.0.0.0/0", ]
  }
}
variable "subnet_count" {
  description = "Number of instances to provision."
  type        = map(number)
  default = {
    dev = 2
    stg = 2
    prd = 2
  }
}
variable "vpc_cidr" {
  description = "VPC CIDR blocks"
  type        = string
}
variable "task_role_arn" {
  description = "(Optional) The ARN of IAM role that grants permissions to the actual application once the container is started (e.g access an S3 bucket or DynamoDB database). If not specified, `aws_iam_role.ecs_task_execution_role.arn` is used"
  type        = string
  default     = null
}