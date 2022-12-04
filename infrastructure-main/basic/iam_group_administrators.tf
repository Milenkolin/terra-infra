resource "aws_iam_group" "administrators" {
  name = "Administrators"
}

resource "aws_iam_group_membership" "administrators" {
  name  = "Administrators"
  group = aws_iam_group.administrators.name

  users = [
    aws_iam_user.devops.name,
    aws_iam_user.lucas.name,
    aws_iam_user.martin.name,
    aws_iam_user.netframe.name
  ]
}

resource "aws_iam_group_policy_attachment" "administrators" {
  for_each = toset([
    "${aws_iam_policy.amazon_grafana_cloudwatch.arn}",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    "arn:aws:iam::aws:policy/AdministratorAccess",
    "arn:aws:iam::aws:policy/AWSGrafanaWorkspacePermissionManagement",
    "arn:aws:iam::aws:policy/service-role/AmazonGrafanaRedshiftAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonGrafanaAthenaAccess",
    "arn:aws:iam::aws:policy/AWSGrafanaAccountAdministrator",
    "arn:aws:iam::aws:policy/AWSGrafanaConsoleReadOnlyAccess"
  ])

  group      = aws_iam_group.administrators.name
  policy_arn = each.key
}
