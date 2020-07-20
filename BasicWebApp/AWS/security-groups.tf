/* WebDMZ security group */
resource "aws_security_group" "web_dmz" {
  name = "web_dmz_group"
  description = "Allows inbound HTTP and SSH to all instances in the VPC"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
  
  tags = {
    Name = "web_dmz" 
  }
}

/* Application Load Balancer Security Group */
resource "aws_security_group" "alb" {
  name        = "main-alb"
  description = "Security group for main web application load balancer"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  tags = {
    Name    = "main-alb-ingress"
    Service = "web"
  }
}
/*
# Security Group rule allowing Port 80 from internet into the load balancer 
resource "aws_security_group_rule" "main-alb-web-ingress-80" {
  depends_on        = [aws_security_group.alb]
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = ["0.0.0.0/0"]
}
*/