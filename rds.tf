resource "aws_db_instance" "cloudiar" {
  name                   = "cloudiar"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  username               = "cloudiar"
  password               = "cloudiar"
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.cloudiar_subnet_group.name
}

resource "aws_db_subnet_group" "cloudiar_subnet_group" {
  subnet_ids = aws_subnet.private_subnet.*.id
  name       = "cloudiar-rds"

  tags = {
    Name = "Cloudiar RDS Subnet Group"
  }
}


resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow traffic for RDS"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.nat_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_ip]
  }

}
