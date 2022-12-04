resource "aws_efs_file_system" "metabase_db" {
  creation_token   = "quickCreated-2fa06904-4ad9-431f-9c2f-8625dcde40b7"
  encrypted        = true
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "metabase-federated-datasource"
  }
}


resource "aws_ecs_task_definition" "metabase_db_service" {
  family                   = "${data.terraform_remote_state.prod_cluster.outputs.environment}-metabase-federated-datasource"
  requires_compatibilities = ["EC2"]

  container_definitions = <<EOF
[
    {
      "dnsSearchDomains": null,
      "environmentFiles": null,
      "logConfiguration": {
        "logDriver": "awslogs",
        "secretOptions": null,
        "options": {
          "awslogs-group": "/ecs/prod-metabase-federated-datasource",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "entryPoint": null,
      "portMappings": [
        {
          "hostPort": 3306,
          "protocol": "tcp",
          "containerPort": 3306
        }
      ],
      "command": [
        "--character-set-server=utf8mb4",
        "--collation-server=utf8mb4_unicode_ci",
        "--federated"
      ],
      "linuxParameters": null,
      "cpu": 1024,
      "environment": [
        {
          "name": "MYSQL_ROOT_PASSWORD",
          "value": "local"
        }
      ],
      "resourceRequirements": null,
      "ulimits": null,
      "dnsServers": null,
      "mountPoints": [
        {
          "readOnly": null,
          "containerPath": "/var/lib/mysql",
          "sourceVolume": "metabase-federated-datasource"
        }
      ],
      "workingDirectory": null,
      "secrets": null,
      "dockerSecurityOptions": null,
      "memory": null,
      "memoryReservation": 900,
      "volumesFrom": [],
      "stopTimeout": null,
      "image": "mysql:8",
      "startTimeout": null,
      "firelensConfiguration": null,
      "dependsOn": null,
      "disableNetworking": null,
      "interactive": null,
      "healthCheck": null,
      "essential": true,
      "links": null,
      "hostname": null,
      "extraHosts": null,
      "pseudoTerminal": null,
      "user": null,
      "readonlyRootFilesystem": null,
      "dockerLabels": null,
      "systemControls": null,
      "privileged": null,
      "name": "prod-metabase-federated-datasource"
    }
  ]
EOF

  volume {
    name = "metabase-federated-datasource"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.metabase_db.id
      root_directory     = "/"
      transit_encryption = "DISABLED"
      authorization_config {
        iam = "DISABLED"
      }
    }
  }
  tags     = {}
  tags_all = {}
}

resource "aws_ecs_service" "metabase_db_service" {
  name                              = "prod-metabase-db-service"
  cluster                           = data.terraform_remote_state.prod_cluster.outputs.cluster_name
  task_definition                   = aws_ecs_task_definition.metabase_db_service.arn
  desired_count                     = 1
  enable_ecs_managed_tags           = true
  health_check_grace_period_seconds = 0
  propagate_tags                    = "NONE"
  wait_for_steady_state             = true

  timeouts {
    create = "5m"
    update = "5m"
  }

  capacity_provider_strategy {
           base              = 0
           capacity_provider = data.terraform_remote_state.prod_cluster.outputs.capacity_provider
           weight            = 1
        }
  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    container_name   = "prod-metabase-federated-datasource"
    container_port   = 3306
    target_group_arn = aws_lb_target_group.metabase_db.arn
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
