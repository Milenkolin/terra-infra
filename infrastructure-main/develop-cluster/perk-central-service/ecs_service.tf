resource "aws_ecs_task_definition" "perk_central_service" {
  family                   = "${data.terraform_remote_state.develop_cluster.outputs.environment}-perk-central-service"
  requires_compatibilities = ["EC2"]
  task_role_arn            = "arn:aws:iam::979370138172:role/develop-perk-central-service-TaskRole-17R0X7XDYF2FV"
  network_mode             = "bridge"

  container_definitions = <<EOF
[
    {
      "dnsSearchDomains": [],
      "environmentFiles": [],
      "logConfiguration": {
        "logDriver": "awslogs",
        "secretOptions": [],
        "options": {
          "awslogs-group": "develop-perk-central-service",
          "awslogs-region": "us-east-1"
        }
      },
      "entryPoint": [],
      "portMappings": [
        {
          "hostPort": 49153,
          "protocol": "tcp",
          "containerPort": 8000
        }
      ],
      "command": [],
      "linuxParameters": null,
      "cpu": 256,
      "environment": [
        {
          "name": "ENV",
          "value": "develop"
        },
        {
          "name": "PORT",
          "value": "8000"
        }
      ],
      "resourceRequirements": null,
      "ulimits": [],
      "dnsServers": [],
      "mountPoints": [],
      "workingDirectory": null,
      "secrets": [],
      "dockerSecurityOptions": [],
      "memory": null,
      "memoryReservation": 900,
      "volumesFrom": [],
      "stopTimeout": null,
      "image": "979370138172.dkr.ecr.us-east-1.amazonaws.com/stockperks/perk-central:${var.docker_image_tag}",
      "startTimeout": null,
      "firelensConfiguration": null,
      "dependsOn": null,
      "disableNetworking": null,
      "interactive": null,
      "healthCheck": null,
      "essential": true,
      "links": [],
      "hostname": null,
      "extraHosts": [],
      "pseudoTerminal": null,
      "user": null,
      "readonlyRootFilesystem": null,
      "dockerLabels": {},
      "systemControls": [],
      "privileged": null,
      "name": "develop-perk-central-service"
    }
  ]
EOF
  tags                  = {}
  tags_all              = {}
}

resource "aws_ecs_service" "perk_central_service" {
  name                               = "develop-perk-central-service-Service-PGtmr8rqavw5"
  cluster                            = data.terraform_remote_state.develop_cluster.outputs.cluster_name
  task_definition                    = "${aws_ecs_task_definition.perk_central_service.id}:${aws_ecs_task_definition.perk_central_service.revision}"
  desired_count                      = 1
  iam_role                           = data.terraform_remote_state.develop_cluster.outputs.cluster_iam_role
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  health_check_grace_period_seconds  = 0
  wait_for_steady_state              = true

  timeouts {
    create = "5m"
    update = "5m"
  }

  capacity_provider_strategy {
    base              = 0
    capacity_provider = data.terraform_remote_state.develop_cluster.outputs.develop_capacity_provider
    weight            = 1
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  ordered_placement_strategy {
    field = "attribute:ecs.availability-zone"
    type  = "spread"
  }


  load_balancer {
    container_name   = "${data.terraform_remote_state.develop_cluster.outputs.environment}-perk-central-service"
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:979370138172:targetgroup/devel-Targe-1FTDMBT39BRX4/209c12fa70876960"
    container_port   = 8000
  }

  placement_constraints {
    type = "distinctInstance"
  }
  tags     = {}
  tags_all = {}
}
