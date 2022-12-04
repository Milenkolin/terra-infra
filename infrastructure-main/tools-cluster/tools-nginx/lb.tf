resource "aws_lb" "tools-LB-Y44KDONJFPYT" {

  name                   = "tools-LoadB-Y44KD0NJFPYT"
  internal               = false
  load_balancer_type     = "application"
  security_groups        = [var.sg_for_lb_Y44]
  subnets                = [
    data.terraform_remote_state.tools_cluster.outputs.public_subnet_id_us-east-1a,
    data.terraform_remote_state.tools_cluster.outputs.public_subnet_id_us-east-1b
  ]
  idle_timeout           = 30
  desync_mitigation_mode = "defensive"
  ip_address_type        = "ipv4"

  tags = {
    "Name" = "tools-cluster-public-lb"
  }

  tags_all = {
    "Name" = "tools-cluster-public-lb"
  }

}
resource "aws_lb_target_group" "tools-nginx-metabase" {
  name                 = "tools-nginx-metabase"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = data.terraform_remote_state.tools_cluster.outputs.vpc_id
  deregistration_delay = 300

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  depends_on = [aws_lb.tools-LB-Y44KDONJFPYT]
}

resource "aws_lb_listener" "http_listener_Y44KDONJFPYT" {
  load_balancer_arn = aws_lb.tools-LB-Y44KDONJFPYT.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_listener_Y44KDONJFPYT" {
  load_balancer_arn = aws_lb.tools-LB-Y44KDONJFPYT.arn
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

resource "aws_lb_listener_rule" "redirect_http_to_https" {
  listener_arn = aws_lb_listener.http_listener_Y44KDONJFPYT.arn

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      host        = "tools.stockperks.com"
      path        = "/metabase/#{path}"
    }
  }

  condition {
    host_header {
      values = ["metabase.tools.stockperks.internal"]
    }
  }
}
