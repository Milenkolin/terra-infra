resource "aws_ecs_task_definition" "surveys" {
  family                   = "${data.terraform_remote_state.prod_cluster.outputs.environment}-surveys"
  task_role_arn            = "arn:aws:iam::979370138172:role/prod-surveys-service-TaskRole-1IKPBH14IMEP3"
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
          "awslogs-group": "prod-surveys",
          "awslogs-region": "us-east-1"
        }
      },
      "entryPoint": [],
      "portMappings": [
        {
          "hostPort": 0,
          "protocol": "tcp",
          "containerPort": 8600
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
      "environment": [
        {
          "name": "ENV",
          "value": "prod"
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
          "value": "8600"
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
      "memory": 2048,
      "memoryReservation": 512,
      "volumesFrom": [],
      "stopTimeout": null,
      "image": "979370138172.dkr.ecr.us-east-1.amazonaws.com/stockperks/surveys:${var.docker_image_tag}",
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
      "name": "prod-surveys"
    }
  ]
EOF

  tags = {}

  tags_all = {}

  volume {
    host_path = "/var/log/microservices"
    name      = "logs"
  }
}

resource "aws_ecs_service" "surveys" {
  name                       = "prod-surveys-service-Service-8gvOzSsZ8fQl"
  cluster                    = "arn:aws:ecs:us-east-1:979370138172:cluster/prod-cluster"
  task_definition            = aws_ecs_task_definition.surveys.arn
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
  tags = {}

  tags_all = {}
}
