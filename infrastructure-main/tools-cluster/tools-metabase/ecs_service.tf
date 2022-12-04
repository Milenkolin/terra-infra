resource "aws_secretsmanager_secret" "metabase_env" {
  name = "metabase"
  description = "Metabase username and password"
  tags = {
    Name = "Metabase"
  }
}

resource "aws_secretsmanager_secret_version" "metabase_env" {
  secret_id     = aws_secretsmanager_secret.metabase_env.arn

  lifecycle {
    ignore_changes = [
      secret_string
    ]
  }
}

locals {
  engine = jsondecode(aws_secretsmanager_secret_version.metabase_env.secret_string)["engine"]
  dbname = jsondecode(aws_secretsmanager_secret_version.metabase_env.secret_string)["dbInstanceIdentifier"]
  port = jsondecode(aws_secretsmanager_secret_version.metabase_env.secret_string)["port"]
  password = jsondecode(aws_secretsmanager_secret_version.metabase_env.secret_string)["password"]
  username = jsondecode(aws_secretsmanager_secret_version.metabase_env.secret_string)["username"]
  enc_secret = jsondecode(aws_secretsmanager_secret_version.metabase_env.secret_string)["encryptionSecret"]
}

resource "aws_ecs_task_definition" "tools_metabase_service" {
  family                   = "tools-metabase"
  task_role_arn            = "arn:aws:iam::979370138172:role/develop-website-backend-TaskRole-GVSU7YHISFJ7"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"

  container_definitions = <<EOF
[
    {
      "dnsSearchDomains": [],
      "environmentFiles": null,
      "logConfiguration": {
        "logDriver": "awslogs",
        "secretOptions": null,
        "options": {
          "awslogs-group": "/ecs/metabase",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "entryPoint": [],
      "portMappings": [
        {
          "hostPort": 49175,
          "protocol": "tcp",
          "containerPort": 3000
        }
      ],
      "command": [],
      "linuxParameters": null,
      "cpu": 1024,
      "environment": [
        {
          "name": "MB_DB_DBNAME",
          "value": "${local.dbname}"
        },
        {
          "name": "MB_DB_HOST",
          "value": "metabase.c8wvrg8rldxd.us-east-1.rds.amazonaws.com"
        },
        {
          "name": "MB_DB_PASS",
          "value": "${local.password}"
        },
        {
          "name": "MB_DB_PORT",
          "value": "${local.port}"
        },
        {
          "name": "MB_DB_TYPE",
          "value": "${local.engine}"
        },
        {
          "name": "MB_DB_USER",
          "value": "${local.username}"
        },
        {
          "name": "MB_ENCRYPTION_SECRET_KEY",
          "value": "${local.enc_secret}"
        },
        {
          "name": "MB_REDIRECT_ALL_REQUESTS_TO_HTTPS",
          "value": "false"
        },
        {
          "name": "MB_SITE_URL",
          "value": "https://tools.stockperks.com/metabase"
        }
      ],
      "resourceRequirements": null,
      "ulimits": null,
      "dnsServers": [],
      "mountPoints": [],
      "workingDirectory": null,
      "secrets": null,
      "dockerSecurityOptions": [],
      "memory": null,
      "memoryReservation": 1024,
      "volumesFrom": [],
      "stopTimeout": null,
      "image": "979370138172.dkr.ecr.us-east-1.amazonaws.com/metabase/metabase:latest",
      "startTimeout": null,
      "firelensConfiguration": null,
      "dependsOn": null,
      "disableNetworking": null,
      "interactive": null,
      "healthCheck": null,
      "essential": true,
      "links": [],
      "hostname": null,
      "extraHosts": null,
      "pseudoTerminal": null,
      "user": null,
      "readonlyRootFilesystem": null,
      "dockerLabels": null,
      "systemControls": [],
      "privileged": null,
      "name": "tools-metabase"
    }
  ]
EOF
  tags = {}
  tags_all = {}
}

resource "aws_ecs_service" "tools_metabase_service" {
  name                              = "tools-metabase"
  cluster                           = data.terraform_remote_state.tools_cluster.outputs.cluster_name
  task_definition                   = "${aws_ecs_task_definition.tools_metabase_service.id}:${aws_ecs_task_definition.tools_metabase_service.revision}"
  enable_ecs_managed_tags           = true
  health_check_grace_period_seconds = 0
  launch_type                       = "EC2"
  desired_count                     = 1
  iam_role                          = "tools-cluster-ECSRole-1H0AQTSFTX3BE"
  propagate_tags                    = "NONE"

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    container_name   = "tools-metabase"
    container_port   = 3000
    target_group_arn = aws_lb_target_group.tools_metabase_tg.arn
  }

  ordered_placement_strategy {
    field = "attribute:ecs.availability-zone"
    type  = "spread"
  }

  ordered_placement_strategy {
    field = "instanceId"
    type  = "spread"
  }

  tags     = {}
  tags_all = {}
}
