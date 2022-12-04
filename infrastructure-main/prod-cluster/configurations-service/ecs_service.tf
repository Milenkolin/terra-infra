resource "aws_ecs_task_definition" "configurations" {
  family                   = "${data.terraform_remote_state.prod_cluster.outputs.environment}-configurations-service"
  task_role_arn            = "arn:aws:iam::979370138172:role/prod-iam-roles-NinthWaveIAMRole-1077G8LYHL45D"
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
            "awslogs-group": "prod-configurations-service",
            "awslogs-region": "us-east-1"
          }
        },
        "entryPoint": [],
        "portMappings": [
          {
            "hostPort": 49150,
            "protocol": "tcp",
            "containerPort": 8333
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
            "value": "prod"
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
            "value": "8333"
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
        "memory": 1000,
        "memoryReservation": 600,
        "volumesFrom": [],
        "stopTimeout": null,
        "image": "979370138172.dkr.ecr.us-east-1.amazonaws.com/stockperks/configurations:${var.docker_image_tag}",
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
        "name": "prod-configurations-service"
  }
  ]
EOF

  volume {
    host_path = "/var/log/microservices"
    name      = "logs"
  }

  tags = {

  }
  tags_all = {

  }

}

resource "aws_ecs_service" "configurations" {
  name                              = "${data.terraform_remote_state.prod_cluster.outputs.environment}-configurations-service-Service-ZRpV7zoT88Dz"
  cluster                           = "arn:aws:ecs:us-east-1:979370138172:cluster/prod-cluster"
  task_definition                   = aws_ecs_task_definition.configurations.arn
  iam_role                          = "aws-service-role"
  desired_count                     = 3
  deployment_maximum_percent        = 250
  propagate_tags                    = "NONE"
  health_check_grace_period_seconds = 0
  wait_for_steady_state             = true

  timeouts {
    create = "5m"
    update = "5m"
  }

  deployment_controller {
    type = "ECS"
  }

  capacity_provider_strategy {
    base              = 1
    capacity_provider = data.terraform_remote_state.prod_cluster.outputs.capacity_provider
    weight            = 1
  }

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.configurations_tg.arn
    container_name   = "${data.terraform_remote_state.prod_cluster.outputs.environment}-configurations-service"
    container_port   = 8333
  }

  placement_constraints {
    type = "distinctInstance"
  }

  ordered_placement_strategy {
    field = "attribute:ecs.availability-zone"
    type  = "spread"
  }

  tags = {

  }
  tags_all = {

  }
}
