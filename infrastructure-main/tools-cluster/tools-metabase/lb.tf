resource "aws_lb" "tools_metabase_lb" {
  name                   = "tools-LoadB-7CSL4Z59XQ1H"
  internal               = true
  load_balancer_type     = "application"
  security_groups        = ["sg-050f6a39847405370"]
  subnets                = ["subnet-0845f68f97c9203b7", "subnet-0eff3147d2e775bd6"]
  idle_timeout           = 30
  desync_mitigation_mode = "defensive"
  ip_address_type        = "ipv4"

  tags = {
    Name = "tools-cluster-internal-lb"
  }
}

resource "aws_lb_target_group" "tools_metabase_tg" {
  name                          = "tools-metabase"
  port                          = 80
  protocol                      = "HTTP"
  vpc_id                        = "vpc-082e09137a512051b"
  load_balancing_algorithm_type = "round_robin"
  deregistration_delay          = 10

  health_check {
    enabled             = true
    path                = "/metabase"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags     = {}
  tags_all = {}

  depends_on = [aws_lb.tools_metabase_lb]
}

resource "aws_lb_target_group" "tools_targe_tg" {
  name                 = "tools-Targe-COW8TGBEHFB9"
  port                 = 80
  target_type          = "instance"
  protocol             = "HTTP"
  vpc_id               = "vpc-082e09137a512051b"
  deregistration_delay = 10

  health_check {
    enabled             = true
    path                = "/health"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  depends_on = [aws_lb.tools_metabase_lb]
}

resource "aws_lb_listener" "tools_metabase_http_listener" {
  load_balancer_arn = aws_lb.tools_metabase_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "ok"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "tools_metabase_https_listener" {
  load_balancer_arn = aws_lb.tools_metabase_lb.arn
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

resource "aws_lb_listener_rule" "metabase_redirect_http_to_https" {
  listener_arn = aws_lb_listener.tools_metabase_http_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tools_metabase_tg.arn
  }

  condition {
    host_header {
      values = ["metabase.tools.stockperks.internal"]
    }
  }
}

resource "aws_lb_listener_rule" "infra_bot_redirect_http_to_https" {
  listener_arn = aws_lb_listener.tools_metabase_http_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tools_targe_tg.arn
  }

  condition {
    host_header {
      values = ["infra-bot.tools.stockperks.internal"]
    }
  }
}
