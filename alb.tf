resource "aws_lb_target_group" "cloudiar" {
  name     = "cloudiar-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

}

resource "aws_lb_target_group_attachment" "cloudiar" {
  count            = var.web_ec2_count
  target_group_arn = aws_lb_target_group.cloudiar.arn
  target_id        = aws_instance.web.*.id[count.index]
  port             = 80
}

resource "aws_lb" "cloudiar" {
  name               = "cloudiar-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = local.pub_sub_ids
  access_logs {
    bucket  = aws_s3_bucket.alb_access_logs.bucket
    enabled = true
  }

  tags = {
    Environment = terraform.workspace
  }
}

resource "aws_lb_listener" "web_tg" {
  load_balancer_arn = aws_lb.cloudiar.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cloudiar.arn
  }
}

data "template_file" "cloudiar" {
  template = file("scripts/iam/alb-s3-access-logs.json")
  vars = {
    access_logs_bucket = "calb-access-logs"
  }
}
