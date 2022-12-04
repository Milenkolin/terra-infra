resource "aws_efs_file_system" "tools_nginx_volume" {
  creation_token   = "console-3a34662b-30cc-45e2-b8a0-48d8f57183d1"
  encrypted        = true
  performance_mode = "generalPurpose"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "tools-nginx"
  }
}

resource "aws_ecs_task_definition" "tools_nginx" {
  family                   = "tools-nginx"
  requires_compatibilities = ["EC2"]

  container_definitions = <<EOF
[
    {
      "dnsSearchDomains": null,
      "environmentFiles": null,
      "logConfiguration": null,
      "entryPoint": null,
      "portMappings": [
        {
          "hostPort": 49176,
          "protocol": "tcp",
          "containerPort": 80
        }
      ],
      "command": null,
      "linuxParameters": null,
      "cpu": 512,
      "environment": [],
      "resourceRequirements": null,
      "ulimits": null,
      "dnsServers": null,
      "mountPoints": [
        {
          "readOnly": false,
          "containerPath": "/etc/nginx/conf.d",
          "sourceVolume": "tools-nginx-volume"
        }
      ],
      "workingDirectory": null,
      "secrets": null,
      "dockerSecurityOptions": null,
      "memory": null,
      "memoryReservation": 1024,
      "volumesFrom": [],
      "stopTimeout": null,
      "image": "nginx:latest",
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
      "readonlyRootFilesystem": false,
      "dockerLabels": null,
      "systemControls": null,
      "privileged": null,
      "name": "tools-nginx"
    }
  ]
EOF
  volume {
    name = "tools-nginx-volume"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.tools_nginx_volume.id
      root_directory     = "/"
      transit_encryption = "DISABLED"
      authorization_config {
        iam = "DISABLED"
      }
    }
  }
}
resource "aws_ecs_service" "tools_nginx_service" {
  name                              = "tools-nginx"
  cluster                           = data.terraform_remote_state.tools_cluster.outputs.cluster_name
  task_definition                   = aws_ecs_task_definition.tools_nginx.arn
  launch_type                       = "EC2"
  desired_count                     = 1
  iam_role                          = "tools-cluster-ECSRole-1H0AQTSFTX3BE"
  enable_ecs_managed_tags           = true
  health_check_grace_period_seconds = 0
  propagate_tags                    = "NONE"

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    container_name   = "tools-nginx"
    container_port   = 80
    target_group_arn = aws_lb_target_group.tools-nginx-metabase.arn
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