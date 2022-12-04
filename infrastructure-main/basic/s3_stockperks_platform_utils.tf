resource "aws_s3_bucket" "stockperks_platform_utils" {
  provider = aws.west
  bucket   = "stockperks-platform-utils"
}

resource "aws_s3_bucket_versioning" "stockperks_platform_utils" {
  provider = aws.west
  bucket   = aws_s3_bucket.stockperks_platform_utils.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "stockperks_platform_utils" {
  provider                = aws.west
  bucket                  = aws_s3_bucket.stockperks_platform_utils.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "stockperks_platform_utils" {
  provider = aws.west
  bucket   = aws_s3_bucket.stockperks_platform_utils.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

data "aws_iam_policy_document" "stockperks_platform_utils" {
  statement {
    sid       = "S3PolicyStmt-DO-NOT-MODIFY-1641477987224"
    effect    = "Allow"
    resources = ["arn:aws:s3:::stockperks-platform-utils/*"]

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject*",
      "s3:DeleteObjectVersion",
      "s3:DeleteObject",
      "s3:GetObjectVersion",
      "s3:GetObjectAcl",
      "s3:PutObjectAcl",
    ]

    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket_policy" "stockperks_platform_utils" {
  provider = aws.west
  bucket   = aws_s3_bucket.stockperks_platform_utils.id
  policy   = data.aws_iam_policy_document.stockperks_platform_utils.json
}
