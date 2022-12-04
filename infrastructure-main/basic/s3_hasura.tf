resource "aws_s3_bucket" "hasura" {
  bucket = "hasura-us-east-1-stockperks.com"
}

data "aws_iam_policy_document" "hasura" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::hasura-us-east-1-stockperks.com/alb/*"]
    actions   = ["s3:PutObject"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::127311923021:root"]
    }
  }
}
resource "aws_s3_bucket_policy" "hasura" {
  bucket = aws_s3_bucket.hasura.id
  policy = data.aws_iam_policy_document.hasura.json
}

#resource "aws_s3_bucket_public_access_block" "hasura" {
#  bucket = aws_s3_bucket.hasura.id
#
#  block_public_acls       = false
#  block_public_policy     = false
#  ignore_public_acls      = true
#  restrict_public_buckets = false
#}
