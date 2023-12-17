resource "aws_instance" "jumpbox" {
  ami           = "ami-0fc5d935ebf8bc3bc" # specify the AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  key_name      = "project"
  vpc_security_group_ids = [aws_security_group.allow_jumpbox.id]
  tags = {
    Name = "jumpbox"
  }
}

resource "aws_security_group" "allow_jumpbox" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "allow_jumpbox"
  }
}

# Private instances for running your application
resource "aws_instance" "private_instance_1" {
  ami           = "ami-0fc5d935ebf8bc3bc" # specify the AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_1.id
  key_name      = "project"
  vpc_security_group_ids = [aws_security_group.allow_private.id]
  user_data     = file("apache-install.sh")

  tags = {
    Name = "private-instance-1"
  }
}

resource "aws_instance" "private_instance_2" {
  ami           = "ami-0fc5d935ebf8bc3bc" # specify the AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_2.id
  key_name      = "project"
  vpc_security_group_ids = [aws_security_group.allow_private.id]
  user_data     = file("apache-install.sh")

  tags = {
    Name = "private-instance-2"
  }
}
resource "aws_security_group" "allow_private" {
  vpc_id = aws_vpc.my_vpc.id

    ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    /* Modify the source as per your requirement,
    0.0.0.0/0 essentially allows traffic from any IP, 
    hence it is highly recommended to restrict the source CIDR block */
    cidr_blocks = ["10.0.0.0/16"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_alb" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Application load balancer
resource "aws_lb" "app_lb" {
  name               = "my-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_alb.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Name = "my-app-lb"
  }
}

# Target group for instances
resource "aws_lb_target_group" "tg" {
  name     = "my-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

}

# Register instances to the target group
resource "aws_lb_target_group_attachment" "tga_instance_1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.private_instance_1.id
}

resource "aws_lb_target_group_attachment" "tga_instance_2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.private_instance_2.id
}

# Listener for ALB
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}