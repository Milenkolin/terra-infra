resource "aws_ecs_task_definition" "brokers_api_service" {
  family                   = "${data.terraform_remote_state.prod_cluster.outputs.environment}-brokers-service"
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
           "awslogs-group": "prod-brokers-service",
           "awslogs-region": "us-east-1"
         }
       },
       "entryPoint": [],
       "portMappings": [
         {
           "hostPort": 49154,
           "protocol": "tcp",
           "containerPort": 8544
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
       "cpu": 1024,
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
           "value": "8544"
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
       "memoryReservation": 1024,
       "volumesFrom": [],
       "stopTimeout": null,
       "image": "979370138172.dkr.ecr.us-east-1.amazonaws.com/stockperks/brokers-api:${var.docker_image_tag}",
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
       "name": "prod-brokers-service"
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

resource "aws_ecs_service" "brokers_api_service" {
  name                       = "prod-brokers-api-service-Service-c3DNKCyrYp8R"
  cluster                    = "arn:aws:ecs:us-east-1:979370138172:cluster/prod-cluster"
  task_definition            = aws_ecs_task_definition.brokers_api_service.arn
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
