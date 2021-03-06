resource "aws_launch_configuration" "web_lc" {
  name                 = "web_lc"
  image_id             = var.aws_image[var.aws_region]
  instance_type        = var.aws_instance_type
  key_name             = aws_key_pair.web.key_name
  user_data            = file("scripts/apache.sh")
  iam_instance_profile = aws_iam_instance_profile.s3_ec2_profile.name
  security_groups      = [aws_security_group.nat_sg.id]

}
resource "aws_autoscaling_group" "cloudiar_asg" {
  name             = "cloudiar_asg"
  min_size         = 1
  max_size         = 3
  desired_capacity = 2

  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = local.pub_sub_ids
  launch_configuration      = aws_launch_configuration.web_lc.name
  load_balancers            = [aws_elb.cloudiar_elb.name]
}

resource "aws_autoscaling_policy" "AddInstancesPolicy" {
  name                   = "AddInstancesPolicy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.cloudiar_asg.name
}

resource "aws_cloudwatch_metric_alarm" "avg_cpu_ge_80" {
  alarm_name          = "avg_cpu_ge_80"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.cloudiar_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.AddInstancesPolicy.arn]
}


resource "aws_cloudwatch_metric_alarm" "avg_cpu_le_30" {
  alarm_name          = "avg_cpu_le_30"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  alarm_description   = "This metric monitors ec2 cpu utilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.cloudiar_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.AddInstancesPolicy.arn]
}
