resource "aws_security_group" "data_propagation_service_rds" {
  name   = "${local.env}-data-propagation-service-rds"
  vpc_id = data.terraform_remote_state.develop_cluster.outputs.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = [
      data.terraform_remote_state.develop_cluster.outputs.vpc_cidr_block,
      "11.0.0.0/16", #vpn
      "50.19.45.135/32",
      "52.45.144.63/32",
      "54.81.134.249/32",
      "52.22.161.231/32"
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      data.terraform_remote_state.develop_cluster.outputs.vpc_cidr_block,
      "11.0.0.0/16", #vpn
      "50.19.45.135/32",
      "52.45.144.63/32",
      "54.81.134.249/32",
      "52.22.161.231/32"
    ]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "data_propagation_service" {
  name = "${local.env}-data-propagation-service-rds"
  subnet_ids = [
    data.terraform_remote_state.develop_cluster.outputs.public_subnet_id_us-east-1a,
    data.terraform_remote_state.develop_cluster.outputs.public_subnet_id_us-east-1b
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${local.env}-data-propagation-service-rds"
  }
}

resource "aws_secretsmanager_secret" "dps_rds_password" {
  name = "${local.env}-data-propagation-service-mysql-password"
}

resource "aws_secretsmanager_secret_version" "dps_rds_password" {
  secret_id     = aws_secretsmanager_secret.dps_rds_password.id
  secret_string = aws_db_instance.data_propagation_service.password
}

resource "random_password" "dps_rds_password" {
  length           = 32
  numeric          = true
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_instance" "data_propagation_service" {
  identifier              = "data-propagation-service-${local.env}-rds"
  engine                  = "postgres"
  engine_version          = "14.1"
  instance_class          = "db.t3.micro"
  multi_az                = false
  allocated_storage       = 10
  port                    = 5432
  publicly_accessible     = true
  db_name                 = "lakehouse"
  username                = "postgres"
  password                = random_password.dps_rds_password.result
  backup_retention_period = 0
  skip_final_snapshot     = true
  storage_encrypted       = false
  db_subnet_group_name    = aws_db_subnet_group.data_propagation_service.name
  vpc_security_group_ids  = [aws_security_group.data_propagation_service_rds.id]
}
