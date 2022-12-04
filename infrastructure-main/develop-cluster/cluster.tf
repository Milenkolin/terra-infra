resource "aws_ecs_cluster" "develop_cluster" {
  name = "develop-cluster"
}

resource "aws_iam_instance_profile" "develop_ecs" {
  name = "develop-services-ec2-EC2InstanceProfile-1RJ5U7LU0EHW5"
  role = "develop-cluster-EC2Role-2PJ6DIQ8SDWC"
}

resource "aws_launch_configuration" "develop_ecs" {
  name                 = "develop-services-ec2-ContainerInstances"
  image_id             = "ami-0bb273345f0961e90"
  instance_type        = "t3a.medium"
  iam_instance_profile = aws_iam_instance_profile.develop_ecs.name
  security_groups      = ["sg-0358931ac09ce6885"]
  user_data            = <<EOF
#!/bin/bash -xe
# install packages
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y collectd
yum install -y https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
yum install -y nfs-utils hibagent
# update config
echo ECS_CLUSTER=develop-cluster >> /etc/ecs/ecs.config
echo ECS_ENABLE_CONTAINER_METADATA=true >> /etc/ecs/ecs.config
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:AmazonCloudWatch-develop-cluster-ECS -s
# run signals
/usr/bin/enable-ec2-spot-hibernation
EOF
}

resource "aws_autoscaling_group" "develop_ecs" {
  name                      = "develop-services-ec2-ECSAutoScalingGroup-1MALTADUSBB2L"
  max_size                  = 12
  min_size                  = 2
  desired_capacity          = 8
  health_check_grace_period = 0
  max_instance_lifetime     = 604800
  wait_for_capacity_timeout = "10m"
  force_delete              = false
  force_delete_warm_pool    = false
  launch_configuration      = aws_launch_configuration.develop_ecs.name

  tag {
    key                 = "AmazonECSManaged"
    propagate_at_launch = true
    value               = ""
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "services-develop-cluster"
  }
}

resource "aws_ecs_capacity_provider" "develop_1" {
  name = "develop-service-capacity-provider-1"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.develop_ecs.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status                    = "ENABLED"
      maximum_scaling_step_size = 10
      minimum_scaling_step_size = 1
      target_capacity           = 100
    }
  }
}
