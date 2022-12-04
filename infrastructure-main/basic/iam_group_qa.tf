resource "aws_iam_group" "qa" {
  name = "qa"
}

resource "aws_iam_group_membership" "qa" {
  name  = "QA"
  group = aws_iam_group.qa.name

  users = [
    aws_iam_user.sofia.name
  ]
}

resource "aws_iam_group_policy_attachment" "qa" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AWSDeviceFarmFullAccess"
  ])

  group      = aws_iam_group.qa.name
  policy_arn = each.key
}
