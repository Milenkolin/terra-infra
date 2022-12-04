resource "aws_efs_file_system" "backend_service" {
  creation_token   = "EfsVolume-ZTHiViS3Noln"
  encrypted        = true
  provisioned_throughput_in_mibps = 0
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"

  tags = {
    Name = "develop-website-backend Configuration"
  }
}


resource "aws_ecs_task_definition" "backend_service" {
  family                   = "develop-website-backend"
  task_role_arn            = "arn:aws:iam::979370138172:role/develop-website-backend-TaskRole-GVSU7YHISFJ7"
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
          "awslogs-group": "develop-website-backend",
          "awslogs-region": "us-east-1"
        }
      },
      "entryPoint": [],
      "portMappings": [
        {
          "hostPort": 49155,
          "protocol": "tcp",
          "containerPort": 1337
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
          "value": "1337"
        }
      ],
      "resourceRequirements": null,
      "ulimits": [],
      "dnsServers": [],
      "mountPoints": [
        {
          "readOnly": false,
          "containerPath": "/srv/app/public/uploads",
          "sourceVolume": "develop-website-backend_volume_uploads"
        }
      ],
      "workingDirectory": null,
      "secrets": [],
      "dockerSecurityOptions": [],
      "memory": null,
      "memoryReservation": 256,
      "volumesFrom": [],
      "stopTimeout": null,
      "image": "979370138172.dkr.ecr.us-east-1.amazonaws.com/stockperks/website-backend:${var.docker_image_tag}",
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
      "name": "develop-website-backend"
    }
  ]
EOF

  volume {
    name = "develop-website-backend_volume_uploads"
    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.backend_service.id
      root_directory          = "/"
    }
  }


  tags     = {}
  tags_all = {}
}

resource "aws_ecs_service" "backend_service" {
  name                               = "develop-website-backend-Service-za9IGb7HYk2A"
  cluster                            = data.terraform_remote_state.develop_cluster.outputs.cluster_name
  task_definition                    = "${aws_ecs_task_definition.backend_service.id}:${aws_ecs_task_definition.backend_service.revision}"
  health_check_grace_period_seconds  = 30
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 0
  desired_count                      = 2
  iam_role                           = data.terraform_remote_state.develop_cluster.outputs.cluster_iam_role
  enable_ecs_managed_tags            = "false"
  propagate_tags                     = "NONE"
  wait_for_steady_state              = true

  timeouts {
    create = "5m"
    update = "5m"
  }

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  capacity_provider_strategy {
    base              = 0
    capacity_provider = data.terraform_remote_state.develop_cluster.outputs.develop_capacity_provider
    weight            = 1
  }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    container_name   = "develop-website-backend"
    container_port   = 1337
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:979370138172:targetgroup/devel-Targe-16PBXCM4LRZ2A/a30a2780ac16af1a"
  }

  placement_constraints {
    type = "distinctInstance"
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
