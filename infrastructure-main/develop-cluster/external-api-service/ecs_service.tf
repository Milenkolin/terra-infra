resource "aws_ecs_task_definition" "external_api" {
  family                   = "${data.terraform_remote_state.develop_cluster.outputs.environment}-external-proxy-service"
  task_role_arn            = "arn:aws:iam::979370138172:role/develop-external-api-service-TaskRole-1P9XCDT3AM8JP"
  requires_compatibilities = ["EC2"]
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
          "awslogs-group": "${data.terraform_remote_state.develop_cluster.outputs.environment}-external-proxy-service",
          "awslogs-region": "${data.terraform_remote_state.develop_cluster.outputs.region}"
        }
      },
      "entryPoint": [],
      "portMappings": [
        {
          "hostPort": 49153,
          "protocol": "tcp",
          "containerPort": 8100
        }
      ],
      "command": [],
      "linuxParameters": {
        "capabilities": null,
        "sharedMemorySize": null,
        "tmpfs": [],
        "devices": [],
        "maxSwap": 256,
        "swappiness": 60,
        "initProcessEnabled": null
      },
      "cpu": 512,
      "environment": [
        {
          "name": "ENV",
          "value": "develop"
        },
        {
          "name": "EUREKA_FETCH_REGISTRY",
          "value": "true"
        },
        {
          "name": "EUREKA_INSTANCE_IP",
          "value": "true"
        },
        {
          "name": "EUREKA_SERVER_DNS",
          "value": "orchestrator.develop.stockperks.internal"
        },
        {
          "name": "EUREKA_USE_DNS",
          "value": "true"
        },
        {
          "name": "IS_AWS",
          "value": "true"
        },
        {
          "name": "PORT",
          "value": "8100"
        },
        {
          "name": "REGISTER_WITH_OTHER_EUREKA",
          "value": "true"
        }
      ],
      "resourceRequirements": null,
      "ulimits": [],
      "dnsServers": [],
      "mountPoints": [
        {
          "readOnly": false,
          "containerPath": "/logs",
          "sourceVolume": "logs"
        }
      ],
      "workingDirectory": null,
      "secrets": [],
      "dockerSecurityOptions": [],
      "memory": null,
      "memoryReservation": 512,
      "volumesFrom": [],
      "stopTimeout": null,
      "image": "979370138172.dkr.ecr.us-east-1.amazonaws.com/stockperks/external-api:${var.docker_image_tag}",
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
      "name": "${data.terraform_remote_state.develop_cluster.outputs.environment}-external-proxy-service"
    }
  ]
EOF

  volume {
    host_path = "/var/log/microservices"
    name      = "logs"
  }
}

resource "aws_ecs_service" "external_api" {
  name                       = "develop-external-api-service-Service-vKuq3ZUuHMY3"
  cluster                    = data.terraform_remote_state.develop_cluster.outputs.cluster_name
  task_definition            = aws_ecs_task_definition.external_api.arn
  desired_count              = 2
  deployment_maximum_percent = 250
  propagate_tags             = "NONE"
  wait_for_steady_state      = true

  timeouts {
    create = "5m"
    update = "5m"
  }

  capacity_provider_strategy {
    base              = 0
    capacity_provider = data.terraform_remote_state.develop_cluster.outputs.develop_capacity_provider
    weight            = 1
  }

  load_balancer {
    container_name   = "develop-external-proxy-service"
    container_port   = 8100
    target_group_arn = aws_lb_target_group.external_api.arn
  }

  placement_constraints {
    type = "distinctInstance"
  }

  ordered_placement_strategy {
    field = "attribute:ecs.availability-zone"
    type  = "spread"
  }
}
