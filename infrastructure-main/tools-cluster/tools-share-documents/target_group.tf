resource "aws_lb_target_group" "tools_share_documents" {
  name                 = "ecs-tools-tools-share-documents"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = data.terraform_remote_state.tools_cluster.outputs.vpc_id
  deregistration_delay = 30

  health_check {
    enabled             = true
    path                = "/share-documents/actuator/health"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  depends_on = [aws_lb.tools_share_documents]
}
