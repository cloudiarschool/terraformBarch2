resource "aws_subnet" "private_subnet" {
  count             = length(slice(local.az_names, 0, 2))
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + length(local.az_names))
  availability_zone = local.az_names[count.index]

  tags = {
    Name = "PrivateSubnet-${count.index + 1}"
  }
}


#NAT Instance
resource "aws_instance" "nat" {
  ami                    = var.aws_image[var.aws_region]
  subnet_id              = local.pub_sub_ids[0]
  instance_type          = var.aws_instance_type
  source_dest_check      = false
  vpc_security_group_ids = [aws_security_group.nat_sg.id]

  tags = {
    Name = "CloudiarNAT"
  }

}

resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block  = var.public_ip
    instance_id = aws_instance.nat.id
  }

  tags = {
    Name = "CloudiarPrivateRT-${terraform.workspace}"
  }
}
resource "aws_route_table_association" "private_rt_association" {
  count          = length(slice(local.az_names, 0, 2))
  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
  route_table_id = aws_route_table.privatert.id

}
