resource "aws_lb" "tools_share_documents" {
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

resource "aws_lb_listener" "tools_share_documents" {
  load_balancer_arn = aws_lb.tools_share_documents.arn
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

resource "aws_lb_listener_rule" "tools_share_documents" {
  listener_arn = aws_lb_listener.tools_share_documents.arn

  action {
    order            = 1
    type             = "forward"
    target_group_arn = aws_lb_target_group.tools_share_documents.arn
  }

  condition {
    path_pattern {
      values = ["/share-documents/*", "/share-documents", "/share-documents/"]
    }
  }
  tags     = {}
  tags_all = {}
}
