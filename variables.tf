variable "vpc_cidr" {
  description = "Choose cidr for vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_region" {
  description = "Choose the right region"
  type        = string
  default     = "us-east-1"
}

variable "public_ip" {
  description = "Use for public affairs"
  type        = string
  default     = "0.0.0.0/0"
}
