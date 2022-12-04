resource "aws_secretsmanager_secret" "datadog_env" {
  name        = "API_Key_Datadog"
  description = "API key for Datadog"
}

resource "aws_secretsmanager_secret_version" "datadog_env" {
  secret_id = aws_secretsmanager_secret.datadog_env.arn

  lifecycle {
    ignore_changes = [
      secret_string
    ]
  }
}

locals {
  api = jsondecode(aws_secretsmanager_secret_version.datadog_env.secret_string)["API_KEY"]
}


resource "aws_ecs_task_definition" "datadog" {
  family        = "${data.terraform_remote_state.prod_cluster.outputs.environment}-datadog-monitoring-service"
  task_role_arn = aws_iam_role.ecs-datadog-role.arn

  container_definitions = <<EOF
[
  {
      "name": "datadog-agent",
      "image": "datadog/agent:latest",
      "cpu": null,
      "memoryReservation": 256,
      "essential": true,
      "mountPoints": [
        {
          "containerPath": "/var/run/docker.sock",
          "sourceVolume": "docker_sock",
          "readOnly": true
        },
        {
          "containerPath": "/host/sys/fs/cgroup",
          "sourceVolume": "cgroup",
          "readOnly": true
        },
        {
          "containerPath": "/host/proc",
          "sourceVolume": "proc",
          "readOnly": true
        }
      ],
      "environment": [
        {
          "name": "DD_API_KEY",
          "value": "${local.api}"
        },
        {
          "name": "DD_SITE",
          "value": "datadoghq.com"
        },
        {
          "name": "DD_APM_ENABLED",
          "value": "false"
        }
      ],
      "portMappings": [
        {
          "protocol": "tcp",
          "containerPort": 8126
        }
      ]
  }
]
EOF

  volume {
    name      = "docker_sock"
    host_path = "/var/run/docker.sock"
  }

  volume {
    name      = "proc"
    host_path = "/proc/"
  }

  volume {
    name      = "cgroup"
    host_path = "/cgroup/"
  }
}

resource "aws_ecs_service" "datadog" {
  name            = "${data.terraform_remote_state.prod_cluster.outputs.environment}-datadog-monitoring-service"
  cluster         = "arn:aws:ecs:us-east-1:979370138172:cluster/prod-cluster"
  task_definition = aws_ecs_task_definition.datadog.arn
  launch_type     = "EC2"
  # This allows running once for every instance
  scheduling_strategy = "DAEMON"
}
