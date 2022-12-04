resource "aws_lb" "configurations_lb_4X86" {
  name               = "prod-LoadB-4X86UTFIMTNT"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.sg_for_lb_4X86]
  subnets = [
    data.terraform_remote_state.prod_cluster.outputs.private_subnet_id_us-east-1a,
    data.terraform_remote_state.prod_cluster.outputs.private_subnet_id_us-east-1b
  ]
  idle_timeout           = 30
  desync_mitigation_mode = "defensive"
  ip_address_type        = "ipv4"

  tags = {
    "Name" = "prod-cluster-internal-lb"
  }

  tags_all = {
    "Name" = "prod-cluster-internal-lb"
  }

}

resource "aws_lb_listener" "configurations_https" {
  load_balancer_arn = aws_lb.configurations_lb_4X86.arn
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

resource "aws_lb_listener" "configurations_http" {
  load_balancer_arn = aws_lb.configurations_lb_4X86.arn
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

resource "aws_lb_listener_rule" "configurations" {
  listener_arn = aws_lb_listener.configurations_http.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.configurations_tg.arn
  }

  condition {
    host_header {
      values = ["configurations.prod.stockperks.internal", "api.stockperks.com"]
    }
  }
  tags     = {}
  tags_all = {}
}
