resource "aws_ecs_task_definition" "hazelcast_service" {
  family                   = "${data.terraform_remote_state.develop_cluster.outputs.environment}-hazelcast"
  requires_compatibilities = ["EC2"]
  task_role_arn            = "arn:aws:iam::979370138172:role/develop-hazelcast-service-TaskRole-B50ANYH2MLG8"
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
          "awslogs-group": "develop-hazelcast",
          "awslogs-region": "us-east-1"
        }
      },
      "entryPoint": [],
      "portMappings": [
        {
          "hostPort": 0,
          "protocol": "tcp",
          "containerPort": 5701
        }
      ],
      "command": [],
      "linuxParameters": {
        "capabilities": null,
        "sharedMemorySize": null,
        "tmpfs": [],
        "devices": [],
        "maxSwap": 512,
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
          "value": "5701"
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
      "image": "979370138172.dkr.ecr.us-east-1.amazonaws.com/stockperks/hazelcast:${var.docker_image_tag}",
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
      "name": "develop-hazelcast"
    }
  ]
EOF

  volume {
    host_path = "/var/log/microservices"
    name      = "logs"
  }
  tags     = {}
  tags_all = {}
}

resource "aws_ecs_service" "hazelcast_service" {
  name                               = "develop-hazelcast-service-Service-3sbDhHNQxwHy"
  cluster                            = data.terraform_remote_state.develop_cluster.outputs.cluster_name
  task_definition                    = "${aws_ecs_task_definition.hazelcast_service.id}:${aws_ecs_task_definition.hazelcast_service.revision}"
  desired_count                      = 3
  deployment_maximum_percent         = 250
  deployment_minimum_healthy_percent = 100
  health_check_grace_period_seconds  = 0
  propagate_tags                     = "NONE"
  wait_for_steady_state              = true

  timeouts {
    create = "5m"
    update = "5m"
  }

  capacity_provider_strategy {
    base              = 1
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


  placement_constraints {
    type = "distinctInstance"
  }
  tags     = {}
  tags_all = {}
}
