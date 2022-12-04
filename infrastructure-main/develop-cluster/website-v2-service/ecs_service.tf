resource "aws_ecs_task_definition" "website_v2" {
  family                   = "${data.terraform_remote_state.develop_cluster.outputs.environment}-website-v2"
  task_role_arn            = "arn:aws:iam::979370138172:role/develop-website-v2-service-TaskRole-XGTOQVKAEJP7"
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
          "awslogs-group": "develop-website-v2",
          "awslogs-region": "us-east-1"
        }
      },
      "entryPoint": [],
      "portMappings": [
        {
          "hostPort": 49162,
          "protocol": "tcp",
          "containerPort": 8000
        }
      ],
      "command": [],
      "linuxParameters": null,
      "cpu": 256,
      "environment": [
        {
          "name": "ENV",
          "value": "develop"
        },
        {
          "name": "PORT",
          "value": "8000"
        }
      ],
      "resourceRequirements": null,
      "ulimits": [],
      "dnsServers": [],
      "mountPoints": [],
      "workingDirectory": null,
      "secrets": [],
      "dockerSecurityOptions": [],
      "memory": null,
      "memoryReservation": 256,
      "volumesFrom": [],
      "stopTimeout": null,
      "image": "979370138172.dkr.ecr.us-east-1.amazonaws.com/stockperks/website-v2:${var.docker_image_tag}",
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
      "name": "develop-website-v2"
    }
  ]
EOF

  tags = {

  }
  tags_all = {

  }

}

resource "aws_ecs_service" "website_v2" {
  name                               = "develop-website-v2-service-Service-Io43ZCo3Gi4C"
  cluster                            = data.terraform_remote_state.develop_cluster.outputs.cluster_name
  task_definition                    = aws_ecs_task_definition.website_v2.arn
  iam_role                           = data.terraform_remote_state.develop_cluster.outputs.cluster_iam_role
  launch_type                        = "EC2"
  desired_count                      = 1
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  health_check_grace_period_seconds  = 0
  wait_for_steady_state              = true

  timeouts {
    create = "5m"
    update = "5m"
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  load_balancer {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:979370138172:targetgroup/devel-Targe-19AQSQJMB9WAE/80c3e15961965f18"
    container_name   = "${data.terraform_remote_state.develop_cluster.outputs.environment}-website-v2"
    container_port   = 8000
  }

  placement_constraints {
    type = "distinctInstance"
  }

  ordered_placement_strategy {
    field = "attribute:ecs.availability-zone"
    type  = "spread"
  }
}
