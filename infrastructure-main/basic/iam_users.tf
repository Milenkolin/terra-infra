resource "aws_iam_user" "devops" {
  name = "devops"
}

resource "aws_iam_user" "ecr_readonly" {
  name = "ecr-readonly"

  tags = {
    service = "ecr readonly"
  }
}

resource "aws_iam_user" "eduardo" {
  name = "eduardo"

  tags = {
    email = "eduardo@stockperks.com"
  }
}

resource "aws_iam_user" "gaston" {
  name = "Gaston"
}

resource "aws_iam_user" "grafana" {
  name = "grafana"

  tags = {
    environment = "prod"
  }
}

resource "aws_iam_user" "infra_tools" {
  name = "infra-tools"
}

resource "aws_iam_user" "lucas" {
  name = "lucas"
}

resource "aws_iam_user" "martin" {
  name = "Martin"
}

resource "aws_iam_user" "netframe" {
  name = "netframe"
}

resource "aws_iam_user" "sebastian" {
  name = "sebastian"
}

resource "aws_iam_user" "sofia" {
  name = "sofia"
}

resource "aws_iam_user" "strapi" {
  name = "strapi"
}

resource "aws_iam_user" "tatiana" {
  name = "tatiana"
}
