# Imported RDS instances that were not initially made through Terraform.

resource "aws_db_instance" "metabase" {
  identifier              = "metabase"
  engine                  = "mysql"
  engine_version          = "5.7.33"
  instance_class          = "db.t2.micro"
  multi_az                = false
  allocated_storage       = 20
  max_allocated_storage   = 1000
  port                    = 3306
  publicly_accessible     = false
  username                = "metabase"
  backup_retention_period = 7
  skip_final_snapshot     = true
  copy_tags_to_snapshot   = true
  storage_encrypted       = false
  db_subnet_group_name    = "prod-db-subnets-dbsubnetgroup-oabgkcprd296"
  vpc_security_group_ids  = ["sg-0843a50fd08381c9c"] #references prod-cluster-EcsHostSecurityGroup-X6Z0ITPUGH7Y

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_db_instance" "ovpn" {
  identifier              = "ovpn"
  engine                  = "mysql"
  engine_version          = "8.0.23"
  instance_class          = "db.t2.micro"
  availability_zone       = "us-east-1a"
  multi_az                = false
  allocated_storage       = 20
  max_allocated_storage   = 1000
  port                    = 3306
  publicly_accessible     = false
  username                = "root"
  backup_retention_period = 7
  skip_final_snapshot     = true
  copy_tags_to_snapshot   = true
  storage_encrypted       = false
  db_subnet_group_name    = "default-vpc-082e09137a512051b"
  vpc_security_group_ids  = ["sg-0222d7e446b7242e7", "sg-0a475d7e2f8fca12b"] #references tools-cluster-EcsHostSecurityGroup-ZVZIT64K2YKC and default

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_db_instance" "oauth_prod" {
  identifier              = "pm19c0sx4telaqm" # oauth-prod
  engine                  = "mysql"
  engine_version          = "8.0.23"
  instance_class          = "db.t2.micro"
  multi_az                = false
  allocated_storage       = 5
  port                    = 3306
  publicly_accessible     = false
  username                = "stockperks"
  backup_retention_period = 3
  skip_final_snapshot     = true
  copy_tags_to_snapshot   = false
  storage_encrypted       = false
  db_subnet_group_name    = "prod-db-subnets-dbsubnetgroup-oabgkcprd296"
  vpc_security_group_ids  = ["sg-0843a50fd08381c9c"] #references prod-cluster-EcsHostSecurityGroup-X6Z0ITPUGH7Y

  tags = {
    "Name" = "Master Database"
  }

  tags_all = {
    "Name" = "Master Database"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_db_instance" "question_and_answer_prod" {
  identifier              = "pm1g8j272dfgt7m" # question-and-answer-prod
  engine                  = "mysql"
  engine_version          = "8.0.23"
  instance_class          = "db.t2.micro"
  multi_az                = false
  allocated_storage       = 5
  port                    = 3306
  publicly_accessible     = false
  username                = "stockperks"
  backup_retention_period = 3
  skip_final_snapshot     = true
  copy_tags_to_snapshot   = false
  storage_encrypted       = false
  db_subnet_group_name    = "prod-db-subnets-dbsubnetgroup-oabgkcprd296"

  vpc_security_group_ids = ["sg-0843a50fd08381c9c"] #references prod-cluster-EcsHostSecurityGroup-X6Z0ITPUGH7Y

  tags = {
    "Name" = "Master Database"
  }

  tags_all = {
    "Name" = "Master Database"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_db_instance" "internal_api_prod" {
  identifier              = "pmd0g3zk05x1w7" # internal-api-prod
  engine                  = "mysql"
  engine_version          = "8.0.23"
  instance_class          = "db.t2.micro"
  multi_az                = false
  availability_zone       = "us-east-1a"
  allocated_storage       = 5
  port                    = 3306
  publicly_accessible     = false
  username                = "stockperks"
  backup_retention_period = 3
  skip_final_snapshot     = true
  copy_tags_to_snapshot   = false
  storage_encrypted       = false
  db_subnet_group_name    = "prod-db-subnets-dbsubnetgroup-oabgkcprd296"
  vpc_security_group_ids  = ["sg-0843a50fd08381c9c"]

  tags = {
    Name = "Master Database"
  }

  tags_all = {
    "Name" = "Master Database"
  }

  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_db_instance" "surveys_prod" {
  identifier              = "pm1jz489biy6sex" # surveys-prod
  engine                  = "mysql"
  engine_version          = "8.0.23"
  instance_class          = "db.t2.micro"
  availability_zone       = "us-east-1a"
  multi_az                = false
  allocated_storage       = 5
  port                    = 3306
  publicly_accessible     = false
  username                = "stockperks"
  backup_retention_period = 3
  skip_final_snapshot     = true
  copy_tags_to_snapshot   = false
  storage_encrypted       = false
  db_subnet_group_name    = "prod-db-subnets-dbsubnetgroup-oabgkcprd296"
  vpc_security_group_ids  = ["sg-0843a50fd08381c9c"]

  tags = {
    "Name" = "Master Database"
  }

  tags_all = {
    "Name" = "Master Database"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_db_instance" "website_prod" {
  identifier              = "pm1xx0fjugt6q84" # website-prod
  engine                  = "mysql"
  engine_version          = "8.0.23"
  instance_class          = "db.t2.micro"
  availability_zone       = "us-east-1a"
  multi_az                = false
  allocated_storage       = 5
  port                    = 3306
  publicly_accessible     = false
  username                = "stockperks"
  backup_retention_period = 3
  skip_final_snapshot     = true
  copy_tags_to_snapshot   = false
  storage_encrypted       = false
  db_subnet_group_name    = "prod-db-subnets-dbsubnetgroup-oabgkcprd296"

  vpc_security_group_ids = ["sg-0843a50fd08381c9c"] #references prod-cluster-EcsHostSecurityGroup-X6Z0ITPUGH7Y

  tags = {
    "Name" = "Master Database"
  }

  tags_all = {
    "Name" = "Master Database"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_db_instance" "reports_prod" {
  identifier              = "pmmjtofslwqzea" # reports-prod
  engine                  = "mysql"
  engine_version          = "8.0.23"
  instance_class          = "db.t2.micro"
  availability_zone       = "us-east-1b"
  multi_az                = false
  allocated_storage       = 5
  port                    = 3306
  publicly_accessible     = false
  username                = "stockperks"
  backup_retention_period = 1
  skip_final_snapshot     = true
  copy_tags_to_snapshot   = false
  storage_encrypted       = false
  db_subnet_group_name    = "prod-db-subnets-dbsubnetgroup-oabgkcprd296"
  vpc_security_group_ids  = ["sg-0843a50fd08381c9c"] # references prod-cluster-EcsHostSecurityGroup-X6Z0ITPUGH7Y

  tags = {
    "Name" = "Master Database"
  }

  tags_all = {
    "Name" = "Master Database"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_db_instance" "internal_api_readonly_prod" {
  identifier              = "prod-application-readonly" # internal-api-readonly-prod
  instance_class          = "db.t2.micro"
  multi_az                = false
  allocated_storage       = 5
  port                    = 3306
  publicly_accessible     = false
  backup_retention_period = 0
  skip_final_snapshot     = true
  copy_tags_to_snapshot   = false
  storage_encrypted       = false
  db_subnet_group_name    = "prod-db-subnets-dbsubnetgroup-oabgkcprd296"
  vpc_security_group_ids  = ["sg-0843a50fd08381c9c"] #references prod-cluster-EcsHostSecurityGroup-X6Z0ITPUGH7Y

  replicate_source_db = "pmd0g3zk05x1w7"

  lifecycle {
    prevent_destroy = true
  }
}
