resource "aws_ecs_cluster" "prod_cluster" {
  name = "prod-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

}

resource "aws_ecs_cluster_capacity_providers" "prod_ecs" {
  cluster_name = aws_ecs_cluster.prod_cluster.name

  capacity_providers = [aws_ecs_capacity_provider.prod_2.name]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 1
    capacity_provider = aws_ecs_capacity_provider.prod_2.name
  }
}

resource "aws_iam_instance_profile" "prod_ecs" {
  name = "prod-services-ec2-EC2InstanceProfile-1OG7XUHZWDYPY"
  role = "prod-cluster-EC2Role-16WGTLGFIOR9U"
}

resource "aws_launch_configuration" "prod_ecs" {
  name                 = "prod-services-ec2-ContainerInstances"
  image_id             = "ami-00131b70724817da9"
  instance_type        = "t3a.medium"
  key_name             = "ecs-production-cluster"
  iam_instance_profile = aws_iam_instance_profile.prod_ecs.name
  user_data            = <<EOF
#!/bin/bash -xe
# install packages
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y collectd
yum install -y https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
yum install -y nfs-utils hibagent
# update config
echo ECS_CLUSTER=prod-cluster >> /etc/ecs/ecs.config
echo ECS_ENABLE_CONTAINER_METADATA=true >> /etc/ecs/ecs.config
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:AmazonCloudWatch-prod-cluster-ECS -s
# run signals
/usr/bin/enable-ec2-spot-hibernation
EOF
  security_groups      = ["sg-0843a50fd08381c9c"]
}

resource "aws_autoscaling_group" "prod_ecs" {
  name                      = "prod-services-ec2-ECSAutoScalingGroup-OBL62FE28KDS"
  max_size                  = 16
  min_size                  = 2
  desired_capacity          = 8
  health_check_grace_period = 0
  max_instance_lifetime     = 604800
  launch_configuration      = aws_launch_configuration.prod_ecs.name
  service_linked_role_arn   = "arn:aws:iam::979370138172:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"

  tag {
    key                 = "AmazonECSManaged"
    propagate_at_launch = true
    value               = ""
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "services-prod-cluster"
  }
}

resource "aws_ecs_capacity_provider" "prod_2" {
  name = "prod-service-capacity-provider-2"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.prod_ecs.arn
  }
}
