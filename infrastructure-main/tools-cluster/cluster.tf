resource "aws_ecs_cluster" "tools_cluster" {
  name = "tools-cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_launch_configuration" "tools_ecs" {
  name                 = "tools-cluster"
  image_id             = "ami-0bb273345f0961e90"
  instance_type        = "t3a.small"
  iam_instance_profile = "tools-kibana-ec2-EC2InstanceProfile-CT728A4AJ5YX"
  security_groups      = ["sg-0222d7e446b7242e7"]
  key_name             = "ecs-develop-cluster"
  user_data            = <<EOF
#!/bin/bash -xe
echo ECS_CLUSTER=tools-cluster >> /etc/ecs/ecs.config
yum install -y nfs-utils
EOF
}

resource "aws_autoscaling_group" "tools_ecs" {
  name                      = "tools-kibana-ec2-ECSAutoScalingGroup-SBC22N35Q6L7"
  max_size                  = 20
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 0
  max_instance_lifetime     = 0
  wait_for_capacity_timeout = "10m"
  force_delete              = false
  force_delete_warm_pool    = false
  launch_configuration      = aws_launch_configuration.tools_ecs.name

  tag {
    key                 = "AmazonECSManaged"
    propagate_at_launch = true
    value               = ""
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "services-tools-cluster"
  }
}

resource "aws_launch_configuration" "tools_ecs_restricted" {
  name                 = "tools-cluster-restricted"
  image_id             = "ami-0bb273345f0961e90"
  instance_type        = "t3a.small"
  iam_instance_profile = "open-vpn-EC2InstanceProfile-E4HT1D4DHI2I"
  security_groups      = ["sg-0222d7e446b7242e7"]
  key_name             = "ecs-develop-cluster"
  user_data            = <<EOF
#!/bin/bash -xe
echo ECS_CLUSTER=tools-cluster >> /etc/ecs/ecs.config
echo ECS_INSTANCE_ATTRIBUTES={\"placement_restriction\": \"openvpn\"} >> /etc/ecs/ecs.config
yum install -y nfs-utils
EOF
}

resource "aws_autoscaling_group" "tools_ecs_restricted" {
  name                      = "open-vpn-ECSAutoScalingGroup-FYM7CA4TR6TD"
  max_size                  = 6
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 0
  max_instance_lifetime     = 0
  wait_for_capacity_timeout = "10m"
  force_delete              = false
  force_delete_warm_pool    = false
  launch_configuration      = aws_launch_configuration.tools_ecs_restricted.name

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "open-vpn-tools-cluster-instance"
  }
}
