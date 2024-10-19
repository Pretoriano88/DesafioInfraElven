resource "aws_lb" "wordpress_alb" {
  name               = "wordpress-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_docker.id]
  subnets            = [aws_subnet.subnet-public-1a.id, aws_subnet.subnet-public-1b.id]
}

resource "aws_lb_target_group" "wordpress_tg" {
  name        = "wordpress-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.mainvpc.id
  target_type = "instance"
  health_check {
    path     = "/"
    protocol = "HTTP"
  }
}

resource "aws_lb_listener" "wordpress_listener" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
  lb_target_group_arn    = aws_lb_target_group.wordpress_tg.arn
}
