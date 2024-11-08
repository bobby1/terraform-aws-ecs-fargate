# AWS Region
variable "region" {
  description = "Region in which AWS Resources to be created"
  type        = string
}
#
variable "vpc_cidr" {
  type = string
}
#
variable "subnet_count" {
  type = number
}
#
variable "app_count" {
  type = number
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev"
}
# Business Division
variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "eTrigue"
}
      