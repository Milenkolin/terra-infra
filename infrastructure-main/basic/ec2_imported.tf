# Imported EC2 instances that were not initially made through Terraform.

resource "aws_instance" "develop_db_develop_cluster_instance" {
  ami                         = "ami-0bb273345f0961e90"
  associate_public_ip_address = false
  instance_type               = "t3a.micro"
  key_name                    = "ecs-develop-cluster"
  iam_instance_profile        = "develop-db-EC2InstanceProfile-X3FRCLXUQWON"
  subnet_id                   = "subnet-0b0a6d96b7a5abde1"
  availability_zone           = "us-east-1a"
  user_data                   = <<EOF
#!/bin/bash -xe
echo ECS_CLUSTER=develop-cluster >> /etc/ecs/ecs.config
echo ECS_INSTANCE_ATTRIBUTES={\"placement_restriction\": \"database\"} >> /etc/ecs/ecs.config
yum install -y nfs-utils
EOF

  tags = {
    Name = "develop-db-develop-cluster-instance"
  }
}
