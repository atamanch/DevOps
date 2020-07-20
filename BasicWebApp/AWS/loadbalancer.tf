/* Internet-facing Application Load Balancer for Web Server Autoscaling Group */
resource "aws_alb" "alb" {  
  name               = "main-lb-web"
  security_groups    = [aws_security_group.alb.id]
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.main-public-1.id,aws_subnet.main-public-2.id]

  tags = {    
    Name    = "web-alb-main"    
  }
  /* Access logs for the load balancer, S3 bucket name is found in variables.tf */
  access_logs {    
    bucket = var.alb_logs_s3_bucket
    prefix = "ALB-logs"
    enabled = false
  }
}

resource "aws_alb_listener" "web" {
  depends_on        = [aws_alb.alb]
  load_balancer_arn = aws_alb.alb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.web.id
  }
}

resource "aws_alb_target_group" "web" {
  name     = "web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    matcher = "200,403,304"
    interval = 10
  }
}