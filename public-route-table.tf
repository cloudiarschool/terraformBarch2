resource "aws_route_table" "prt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = var.public_ip
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "CloudiarPRT-${terraform.workspace}"
  }

}
