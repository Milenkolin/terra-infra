##
## Configuration for prod load balancer "prod-LoadB-1SB3ODZ5BEMH0"
##

resource "aws_lb" "lb_1SB3" {
  name               = "prod-LoadB-1SB3ODZ5BEMH0"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_for_lb_1SB3]
  subnets = [
    aws_subnet.public_subnet_us-east-1a.id,
    aws_subnet.public_subnet_us-east-1b.id,
  ]
  idle_timeout           = 300
  desync_mitigation_mode = "defensive"
  ip_address_type        = "ipv4"

  tags = {
    "Name" = "prod-cluster-public-lb"
  }

  tags_all = {
    "Name" = "prod-cluster-public-lb"
  }
}

resource "aws_lb_listener" "http_1SB3" {
  load_balancer_arn = aws_lb.lb_1SB3.arn
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

resource "aws_lb_listener" "https_1SB3" {
  load_balancer_arn = aws_lb.lb_1SB3.arn
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

resource "aws_lb_listener_rule" "external_api" {
  listener_arn = aws_lb_listener.https_1SB3.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_api.arn
  }

  condition {
    host_header {
      values = ["api.stockperks.com"]
    }
  }
  tags     = {}
  tags_all = {}
}

resource "aws_lb_listener_rule" "assetlinks" {
  listener_arn = aws_lb_listener.https_1SB3.arn
  priority     = 3

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = jsonencode(
        [
          {
            relation = [
              "delegate_permission/common.handle_all_urls",
            ]
            target = {
              namespace    = "android_app"
              package_name = "com.stockperks.stockperks"
              sha256_cert_fingerprints = [
                "8F:89:35:27:05:6E:6D:BE:E9:1C:41:AE:A3:63:E9:86:0E:97:13:61:4D:B9:ED:64:A1:EE:7D:7D:9D:8E:7F:F9",
                "3B:84:E4:32:B2:81:55:8A:0E:0C:8B:4B:6E:D7:59:B4:00:14:44:5D:0F:69:C0:03:83:04:47:BC:3E:2F:28:98",
              ]
            }
          },
        ]
      )
      status_code = "200"
    }
  }

  condition {
    host_header {
      values = ["stockperks.com", "www.stockperks.com"]
    }
  }
  
  condition {
    path_pattern {
      values = ["/.well-known/assetlinks.json"]
    }
  }
  tags     = {}
  tags_all = {}
}

resource "aws_lb_listener_rule" "perk_central" {
  listener_arn = aws_lb_listener.https_1SB3.arn
  priority     = 6

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.perk_central.arn
  }

  condition {
    host_header {
      values = ["central.stockperks.com"]
    }
  }
  tags     = {}
  tags_all = {}
}

resource "aws_lb_listener_rule" "apple_app_site_association" {
  listener_arn = aws_lb_listener.https_1SB3.arn
  priority     = 31

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = jsonencode( # whitespace changes
        {
          applinks = {
            apps = []
            details = [
              {
                appID = "YN38FRYQGY.com.stockperks.stockperks"
                appIDs = [
                  "YN38FRYQGY.com.stockperks.stockperks",
                ]
                components = [
                  {
                    "/" = "/perks/*"
                  },
                  {
                    "/" = "/perk/*"
                  },
                  {
                    "/" = "/surveys/*"
                  },
                  {
                    "/" = "/survey/*"
                  },
                  {
                    "/" = "/company/*"
                  },
                  {
                    "/" = "/post/*"
                  },
                  {
                    "/" = "/plaid/*"
                  },
                  {
                    "/" = "/signup/*"
                  },
                ]
                paths = [
                  "/perks/*",
                  "/perk/*",
                  "/surveys/*",
                  "/survey/*",
                  "/company/*",
                  "/post/*",
                  "/plaid/",
                  "/signup/*",
                ]
              },
            ]
          }
        }
      )
      status_code = "200"
    }
  }

  condition {
    host_header {
      values = ["stockperks.com", "www.stockperks.com"]
    }
  }

  condition {
    path_pattern {
      values = ["/.well-known/apple-app-site-association"]
    }
  }
  tags     = {}
  tags_all = {}
}

resource "aws_lb_listener_rule" "website_v2" {
  listener_arn = aws_lb_listener.https_1SB3.arn
  priority     = 32

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.website_v2.arn
  }

  condition {
    host_header {
      values = ["stockperks.com", "www.stockperks.com"]
    }
  }
  tags     = {}
  tags_all = {}
}

resource "aws_lb_listener_rule" "website_backend" {
  listener_arn = aws_lb_listener.https_1SB3.arn
  priority     = 33

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.website_backend.arn
  }

  condition {
    host_header {
      values = ["site-backend.stockperks.com"]
    }
  }
  tags     = {}
  tags_all = {}
}

##
## Configuration for prod target groups associated with load balancer "prod-LoadB-1SB3ODZ5BEMH0"
##
resource "aws_lb_target_group" "external_api" {
  name                 = "prod-Targe-11W66YGDNIJBO"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = aws_vpc.vpc_prod_cluster.id
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

  depends_on = [aws_lb.lb_1SB3]
}

resource "aws_lb_target_group" "perk_central" {
  name                 = "prod-Targe-YDE4O4NR8545"
  port                 = 8000
  protocol             = "HTTP"
  vpc_id               = aws_vpc.vpc_prod_cluster.id
  deregistration_delay = 15

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 5
    port                = "traffic-port"
    matcher             = "200"
  }

  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }

  depends_on = [aws_lb.lb_1SB3]

  tags     = {}
  tags_all = {}
}

resource "aws_lb_target_group" "website_v2" {
  name                 = "prod-Targe-XWUY1SYSUQ3D"
  port                 = 8000
  protocol             = "HTTP"
  protocol_version     = "HTTP1"
  vpc_id               = aws_vpc.vpc_prod_cluster.id
  deregistration_delay = 15


  stickiness {
    type    = "lb_cookie"
    enabled = false
  }

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  depends_on = [aws_lb.lb_1SB3]
}

resource "aws_lb_target_group" "website_backend" {
  name                          = "prod-Targe-1R66MFFQX3KHI"
  port                          = 1337
  protocol                      = "HTTP"
  vpc_id                        = aws_vpc.vpc_prod_cluster.id
  load_balancing_algorithm_type = "round_robin"
  slow_start                    = 0
  deregistration_delay          = 15

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    port                = "traffic-port"
    timeout             = 5
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }


  tags     = {}
  tags_all = {}

  depends_on = [aws_lb.lb_1SB3]
}
