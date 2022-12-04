resource "aws_lb_target_group" "configurations_tg" {
  name                 = "${data.terraform_remote_state.prod_cluster.outputs.environment}-configurations-service"
  port                 = 80
  protocol             = "HTTP"
  protocol_version     = "HTTP1"
  vpc_id               = data.terraform_remote_state.prod_cluster.outputs.vpc_id
  deregistration_delay = 60


  stickiness {
    type    = "lb_cookie"
    enabled = false
  }

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

  depends_on = [aws_lb.configurations_lb_4X86]
}
