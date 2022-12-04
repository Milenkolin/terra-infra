resource "aws_ecs_task_definition" "api" {
  family                   = "${data.terraform_remote_state.prod_cluster.outputs.environment}-api-service"
  task_role_arn            = "arn:aws:iam::979370138172:role/prod-api-service-TaskRole-11PNJTNV5CQZ7"
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
          "awslogs-group": "${data.terraform_remote_state.prod_cluster.outputs.environment}-api-service",
          "awslogs-region": "${data.terraform_remote_state.prod_cluster.outputs.region}"
        }
      },
      "entryPoint": [],
      "portMappings": [
        {
          "hostPort": 0,
          "protocol": "tcp",
          "containerPort": 8200
        }
      ],
      "command": [],
      "linuxParameters": {
        "capabilities": null,
        "sharedMemorySize": null,
        "tmpfs": [],
        "devices": [],
        "maxSwap": 768,
        "swappiness": 60,
        "initProcessEnabled": null
      },
      "cpu": 2048,
      "environment": [
        {
          "name": "ENV",
          "value": "${data.terraform_remote_state.prod_cluster.outputs.environment}"
        },
        {
          "name": "EUREKA_INSTANCE_IP",
          "value": "true"
        },
        {
          "name": "EUREKA_SERVER_DNS",
          "value": "orchestrator.prod.stockperks.internal"
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
          "value": "8200"
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
      "memory": 3072,
      "memoryReservation": 2048,
      "volumesFrom": [],
      "stopTimeout": null,
      "image": "979370138172.dkr.ecr.us-east-1.amazonaws.com/stockperks/internal-api:${var.docker_image_tag}",
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
      "name": "${data.terraform_remote_state.prod_cluster.outputs.environment}-api-service"
    }
  ]
EOF

  volume {
    host_path = "/var/log/microservices"
    name      = "logs"
  }
}

resource "aws_ecs_service" "api" {
  name                       = "prod-api-service-Service-WusFzrUgUNXX"
  cluster                    = "arn:aws:ecs:us-east-1:979370138172:cluster/prod-cluster"
  task_definition            = aws_ecs_task_definition.api.arn
  desired_count              = 2
  deployment_maximum_percent = 250
  propagate_tags             = "NONE"
  wait_for_steady_state      = true

  timeouts {
    create = "5m"
    update = "5m"
  }

  capacity_provider_strategy {
    base              = 1
    capacity_provider = data.terraform_remote_state.prod_cluster.outputs.capacity_provider
    weight            = 1
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  placement_constraints {
    type = "distinctInstance"
  }

  ordered_placement_strategy {
    field = "attribute:ecs.availability-zone"
    type  = "spread"
  }
}
