resource "aws_iam_group" "developers" {
  name = "developer"
}

resource "aws_iam_group_membership" "developers" {
  name  = "Developers"
  group = aws_iam_group.developers.name

  users = [
    aws_iam_user.eduardo.name,
    aws_iam_user.gaston.name,
    aws_iam_user.lucas.name,
    aws_iam_user.sebastian.name,
    aws_iam_user.sofia.name,
    aws_iam_user.tatiana.name
  ]
}

resource "aws_iam_group_policy_attachment" "developers" {
  for_each = toset([
    "arn:aws:iam::aws:policy/service-role/AWSQuickSightListIAM",
    "arn:aws:iam::aws:policy/IAMSelfManageServiceSpecificCredentials",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess",
    "arn:aws:iam::aws:policy/IAMUserSSHKeys",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
  ])

  group      = aws_iam_group.developers.name
  policy_arn = each.key
}
