# data "aws_ami" "ubuntu_ami" {
#   most_recent = true
#   owners      = ["aws-marketplace"]
#
#   filter {
#     name = "name"
#
#     values = [
#       "Ubuntu 18.04 *",
#     ]
#   }
#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }
#
#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }
# }
#
# resource "aws_instance" "ubuntu" {
#   instance_type = var.aws_instance_type
#   ami           = data.aws_ami.ubuntu_ami.id
#
#   tags = {
#     Name = "Ubuntu"
#   }
#
# }
