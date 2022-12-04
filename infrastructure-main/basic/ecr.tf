resource "aws_ecr_repository" "springboot_template" {
  name                 = "springboot-template"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "portfolio_manager_service" {
  name                 = "portfolio-manager-service"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}