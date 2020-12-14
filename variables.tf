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

variable "aws_image" {
  description = "Use for nat instance"
  type        = map(string)
  default = {
    us-east-1 = "ami-04d29b6f966df1537"
    us-east-2 = "ami-09558250a3419e7d0"
  }

}

variable "aws_instance_type" {
  description = "Use for nat instance for instance type"
  type        = string
  default     = "t2.micro"

}
variable "aws_instance_name" {
  description = "Use for web instance name"
  type        = map(string)
  default = {
    Name = "WebServer"
  }

}

variable "web_tags" {
  type = map(string)
  default = {
    Name = "WebServer"
  }
}


variable "web_ec2_count" {
  description = "Choose number of ec2 instances for web"
  type        = string
  default     = "2"
}

variable "s3_bucket" {
  type    = string
  default = "cloudiar-s3-bucket"
}
