resource "aws_ecs_task_definition" "qa" {
  family                   = "${data.terraform_remote_state.prod_cluster.outputs.environment}-q-and-a"
  task_role_arn            = "arn:aws:iam::979370138172:role/prod-qa-service-TaskRole-1GO9KWJY4W4KA"
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
         "awslogs-group": "prod-q-and-a",
         "awslogs-region": "us-east-1"
       }
     },
     "entryPoint": [],
     "portMappings": [
       {
         "hostPort": 49155,
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
     "cpu": 256,
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
     "memory": 768,
     "memoryReservation": 300,
     "volumesFrom": [],
     "stopTimeout": null,
     "image": "979370138172.dkr.ecr.us-east-1.amazonaws.com/stockperks/question-and-answer:${var.docker_image_tag}",
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
     "name": "prod-q-and-a"
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

resource "aws_ecs_service" "qa" {
  name                       = "prod-qa-service-Service-rRDAtqd79kKI"
  cluster                    = "arn:aws:ecs:us-east-1:979370138172:cluster/prod-cluster"
  task_definition            = aws_ecs_task_definition.qa.arn
  desired_count              = 3
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
