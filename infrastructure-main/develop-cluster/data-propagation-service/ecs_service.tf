resource "aws_cloudwatch_log_group" "ecs_service" {
  name              = "${local.env}-data-propagation-service"
  retention_in_days = 3
}

resource "aws_ecs_task_definition" "data_propagation_service" {
  family = "service"

  container_definitions = jsonencode([
    {
      name        = "${local.env}-data-propagation-service"
      image       = "979370138172.dkr.ecr.us-east-1.amazonaws.com/stockperks/data-propagation-service:${var.docker_image_tag}"
      cpu         = 512
      memory      = 512
      essential   = true
      environment = jsondecode(var.data_propagation_service_env)
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group  = aws_cloudwatch_log_group.ecs_service.name,
          awslogs-region = "${local.region}"
        }
      }
      mountPoints = [
        {
          readOnly      = false
          containerPath = "/logs"
          sourceVolume  = "logs"
        }
      ]
    }
  ])

  volume {
    host_path = "/var/log/microservices"
    name      = "logs"
  }
}

resource "aws_security_group" "lb_sg" {
  name   = "${local.env}-data-propagation-service-lb"
  vpc_id = data.terraform_remote_state.develop_cluster.outputs.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      data.terraform_remote_state.develop_cluster.outputs.vpc_cidr_block,
      "11.0.0.0/16", #vpn
      "50.19.45.135/32"
    ]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
      data.terraform_remote_state.develop_cluster.outputs.vpc_cidr_block,
      "11.0.0.0/16", #vpn
      "50.19.45.135/32"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "data_propagation_lb" {
  name               = "${local.env}-data-propagation-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets = [
    data.terraform_remote_state.develop_cluster.outputs.private_subnet_id_us-east-1a,
    data.terraform_remote_state.develop_cluster.outputs.private_subnet_id_us-east-1b
  ]
}

resource "aws_lb_target_group" "data_propagation_service" {
  name                 = "${local.env}-data-propagation-service"
  port                 = 8080
  protocol             = "HTTP"
  vpc_id               = data.terraform_remote_state.develop_cluster.outputs.vpc_id
  deregistration_delay = 60

  health_check {
    enabled  = true
    path     = "/"
    protocol = "HTTP"
    interval = 30
    timeout  = 5
    port     = 8080
    matcher  = "200"
  }

  depends_on = [aws_lb.data_propagation_lb]
}

resource "aws_lb_listener" "data_propagation_lb_listener" {
  load_balancer_arn = aws_lb.data_propagation_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.data_propagation_service.arn
  }
}

resource "aws_ecs_service" "data_propagation_service" {
  name            = "${local.env}-data-propagation-service"
  cluster         = data.terraform_remote_state.develop_cluster.outputs.cluster_name
  task_definition = aws_ecs_task_definition.data_propagation_service.arn
  desired_count   = 1
  iam_role        = data.terraform_remote_state.develop_cluster.outputs.cluster_iam_role
  wait_for_steady_state = true

  timeouts {
    create = "5m"
    update = "5m"
  }

  capacity_provider_strategy {
    base              = 0
    capacity_provider = data.terraform_remote_state.develop_cluster.outputs.develop_capacity_provider
    weight            = 1
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.data_propagation_service.arn
    container_name   = "${local.env}-data-propagation-service"
    container_port   = 8080
  }

  placement_constraints {
    type = "distinctInstance"
  }
}

resource "aws_iam_role" "ecs_autoscaler" {
  name = "${local.env}-data-propagation-autoscaler"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_autoscaler" {
  role       = aws_iam_role.ecs_autoscaler.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}

resource "aws_appautoscaling_target" "data_propagation_service_scaling" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${data.terraform_remote_state.develop_cluster.outputs.cluster_name}/${local.env}-data-propagation-service"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = aws_iam_role.ecs_autoscaler.arn
  depends_on         = [aws_ecs_service.data_propagation_service]
}

resource "aws_appautoscaling_policy" "ecs_cpu_autoscaler" {
  name               = "${local.env}-data-propagation-cpu-autoscaler"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.data_propagation_service_scaling.resource_id
  scalable_dimension = aws_appautoscaling_target.data_propagation_service_scaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.data_propagation_service_scaling.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 80
  }

  depends_on = [aws_appautoscaling_target.data_propagation_service_scaling]
}

resource "aws_appautoscaling_policy" "ecs_target_memory" {
  name               = "${local.env}-data-propagation-memory-autoscaler"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.data_propagation_service_scaling.resource_id
  scalable_dimension = aws_appautoscaling_target.data_propagation_service_scaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.data_propagation_service_scaling.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80
  }

  depends_on = [aws_appautoscaling_target.data_propagation_service_scaling]
}
