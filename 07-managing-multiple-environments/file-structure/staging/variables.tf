variable "subnet_id" {
  description = "Subnet ID for the DB instance"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC ID for the DB instance"
  type        = string
  sensitive   = true
}
