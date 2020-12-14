locals {
  pub_sub_ids = aws_subnet.public_subnet.*.id
}

resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = var.public_ip
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "CloudiarPublicRT-${terraform.workspace}"
  }
}

#Public Subnet Association
resource "aws_route_table_association" "pub_sub_association" {
  count          = length(local.az_names)
  route_table_id = aws_route_table.publicrt.id
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]

}
