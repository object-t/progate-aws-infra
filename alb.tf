resource "aws_lb" "this" {
  name               = "${local.name_prefix}-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets = [
    aws_subnet.private["1a"].id,
    aws_subnet.private["1c"].id,
  ]

  tags = {
    Name = "${local.name_prefix}-nlb"
  }
}

resource "aws_lb_target_group" "blue" {
  name        = "${local.name_prefix}-nlb-target-group-blue"
  port        = 8000
  protocol    = "TCP"
  vpc_id      = aws_vpc.this.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${local.name_prefix}-nlb-target-group-blue"
  }
}

resource "aws_lb_target_group" "green" {
  name        = "${local.name_prefix}-nlb-target-group-green"
  port        = 8000
  protocol    = "TCP"
  vpc_id      = aws_vpc.this.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${local.name_prefix}-nlb-target-group-green"
  }
}

resource "aws_lb_listener" "tcp" {
  load_balancer_arn = aws_lb.this.arn
  port              = 8000
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }

  lifecycle {
    ignore_changes = [default_action]
  }
}


