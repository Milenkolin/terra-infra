resource "aws_ecs_task_definition" "tools_share_documents_service" {
  family                   = "tools-share-documents"
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
          "awslogs-group": "/ecs/tools-share-documents",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "entryPoint": null,
      "portMappings": [
        {
          "hostPort": 49179,
          "protocol": "tcp",
          "containerPort": 8080
        }
      ],
      "command": null,
      "linuxParameters": null,
      "cpu": 0,
      "environment": [
        {
          "name": "ENV",
          "value": "local"
        },
        {
          "name": "SERVER_SERVLET_CONTEXT_PATH",
          "value": "/share-documents"
        }
      ],
      "resourceRequirements": null,
      "ulimits": null,
      "dnsServers": null,
      "mountPoints": [],
      "workingDirectory": null,
      "secrets": null,
      "dockerSecurityOptions": null,
      "memory": 512,
      "memoryReservation": 256,
      "volumesFrom": [],
      "stopTimeout": null,
      "image": "979370138172.dkr.ecr.us-east-1.amazonaws.com/stockperks/share-documents:latest",
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
      "name": "share-documents-container"
    }
  ]
EOF
  tags                  = {}
  tags_all              = {}
}

resource "aws_ecs_service" "tools_share_documents_service" {
  name                              = "tools-share-documents"
  cluster                           = data.terraform_remote_state.tools_cluster.outputs.cluster_name
  task_definition                   = "${aws_ecs_task_definition.tools_share_documents_service.id}:${aws_ecs_task_definition.tools_share_documents_service.revision}"
  enable_ecs_managed_tags           = true
  health_check_grace_period_seconds = 0
  launch_type                       = "EC2"
  desired_count                     = 1
  iam_role                          = "tools-cluster-ECSRole-1H0AQTSFTX3BE"
  propagate_tags                    = "NONE"

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    container_name   = "share-documents-container"
    container_port   = 8080
    target_group_arn = aws_lb_target_group.tools_share_documents.arn
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
