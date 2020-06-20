resource "aws_autoscaling_group" "web_server" {
  name                      = "web-server-autoscaling-group"
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  default_cooldown          = 300
  # optional force_delete              = true
  # optional placement_group           = "${aws_placement_group.test.id}"
  launch_configuration      = aws_launch_configuration.web_server.name
  vpc_zone_identifier       = [aws_subnet.main-public-1.id]
  target_group_arns         = [aws_alb_target_group.web.id]

  tag {
    key                 = "Name"
    value               = "ec2-webserver-asg"
    propagate_at_launch = false
  }
}