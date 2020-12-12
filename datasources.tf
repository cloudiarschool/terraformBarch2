#Decalre the AZs dynamically
data "aws_availability_zones" "azs" {
  state = "available"
}
