resource "aws_ecs_task_definition" "brokers_api_service" {
  family                   = "${data.terraform_remote_state.develop_cluster.outputs.environment}-brokers-service"
  task_role_arn            = "arn:aws:iam::979370138172:role/develop-iam-roles-NinthWaveIAMRole-18KWQ49R0TO9N"
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
           "awslogs-group": "develop-brokers-service",
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
       "memory": 900,
       "memoryReservation": 600,
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
       "name": "develop-brokers-service"
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
  name                       = "develop-brokers-api-service-Service-NWdoveTjxnOL"
  cluster                    = data.terraform_remote_state.develop_cluster.outputs.cluster_name
  task_definition            = aws_ecs_task_definition.brokers_api_service.arn
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
  tags = {}

  tags_all = {}
}
