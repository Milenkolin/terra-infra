resource "aws_lb" "external_api" {
  name               = "devel-LoadB-1GPPGJQ8G4AVR"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-084bc55367fa5509d"]

  subnets = [
    data.terraform_remote_state.develop_cluster.outputs.public_subnet_id_us-east-1a,
    data.terraform_remote_state.develop_cluster.outputs.public_subnet_id_us-east-1b
  ]

  idle_timeout           = 30
  desync_mitigation_mode = "defensive"
  ip_address_type        = "ipv4"

  tags = {
    "Name" = "develop-cluster-public-lb"
  }

  tags_all = {
    "Name" = "develop-cluster-public-lb"
  }
}

resource "aws_lb_listener" "external_api" {
  load_balancer_arn = aws_lb.external_api.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:979370138172:certificate/45737c30-1d12-44e0-85f5-530a5f1f42c3"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "ok"
      status_code  = "200"
    }
  }
}

resource "aws_lb_target_group" "external_api" {
  name                 = "devel-Targe-S205K2K6ZOOY"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = data.terraform_remote_state.develop_cluster.outputs.vpc_id
  deregistration_delay = 10

  health_check {
    enabled             = true
    path                = "/actuator/health"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  depends_on = [aws_lb.external_api]
}

resource "aws_lb_listener_rule" "external_api" {
  listener_arn = aws_lb_listener.external_api.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_api.arn
  }

  condition {
    host_header {
      values = ["api-develop.stockperks.com"]
    }
  }
  tags     = {}
  tags_all = {}
}
