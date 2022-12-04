resource "aws_lb" "metabase_db_service" {
  name               = "prod-internal-application"
  internal           = true
  load_balancer_type = "network"
  subnets            = [data.terraform_remote_state.prod_cluster.outputs.private_subnet_id_us-east-1a, data.terraform_remote_state.prod_cluster.outputs.private_subnet_id_us-east-1b]
  ip_address_type    = "ipv4"
  access_logs {
    bucket = ""
    enabled = false
  }
  subnet_mapping {
    subnet_id = data.terraform_remote_state.prod_cluster.outputs.private_subnet_id_us-east-1a
  }
  subnet_mapping {
    subnet_id = data.terraform_remote_state.prod_cluster.outputs.private_subnet_id_us-east-1b
  }
  
}

resource "aws_lb_target_group" "metabase_db" {
  name                   = "prod-metabase-db"
  port                   = 80
  protocol               = "TCP"
  vpc_id                 = data.terraform_remote_state.prod_cluster.outputs.vpc_id
  connection_termination = true
  deregistration_delay   = 10

  health_check {
    enabled  = true
    port     = "traffic-port"
    protocol = "tcp"
    interval = 30
    timeout  = 10
  }
  stickiness {
    cookie_duration = "0"
    enabled         = false
    type            = "source_ip"
  }

  tags     = {}
  tags_all = {}

  depends_on = [aws_lb.metabase_db_service]
}

resource "aws_lb_listener" "metabase_db_service" {
  load_balancer_arn = aws_lb.metabase_db_service.arn
  port              = 3306
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.metabase_db.arn
  }

  tags     = {}
  tags_all = {}
}
