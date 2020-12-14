resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = var.s3_bucket
  acl    = "private"

  tags = {
    Name        = "cloudiar-s3-bucket"
    Environment = terraform.workspace
  }

}
