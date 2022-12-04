resource "aws_ecs_task_definition" "eureka" {
  family                   = "eureka-develop"
  task_role_arn            = "arn:aws:iam::979370138172:role/develop-eureka-service-TaskRole-186W0ONBMXWVX"
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
          "awslogs-group": "eureka-develop",
          "awslogs-region": "${data.terraform_remote_state.develop_cluster.outputs.region}"
        }
      },
      "entryPoint": [],
      "portMappings": [
        {
          "hostPort": 0,
          "protocol": "tcp",
          "containerPort": 8761
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
      "cpu": 256,
      "environment": [
        {
          "name": "ENV",
          "value": "develop"
        },
        {
          "name": "EUREKA_INSTANCE_IP",
          "value": "true"
        },
        {
          "name": "EUREKA_SERVER_DNS",
          "value": "develop.stockperks.internal"
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
          "value": "8761"
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
      "memory": 900,
      "memoryReservation": 600,
      "volumesFrom": [],
      "stopTimeout": null,
      "image": "979370138172.dkr.ecr.us-east-1.amazonaws.com/stockperks/orchestrator:${var.docker_image_tag}",
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
      "name": "eureka-develop"
    }
  ]
EOF

  volume {
    host_path = "/var/log/microservices"
    name      = "logs"
  }
}

resource "aws_ecs_service" "eureka" {
  name                       = "develop-eureka-service-Service-SXqrwrOyQafl"
  cluster                    = data.terraform_remote_state.develop_cluster.outputs.cluster_name
  task_definition            = aws_ecs_task_definition.eureka.arn
  desired_count              = 1
  deployment_maximum_percent = 250
  propagate_tags             = "NONE"
  wait_for_steady_state      = true

  timeouts {
    create = "5m"
    update = "5m"
  }

  capacity_provider_strategy {
    base              = 1
    capacity_provider = data.terraform_remote_state.develop_cluster.outputs.develop_capacity_provider
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
