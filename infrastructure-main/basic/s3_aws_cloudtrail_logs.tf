resource "aws_s3_bucket" "aws_cloudtrail_logs" {
  bucket = "aws-cloudtrail-logs-979370138172-0372718f"
}

data "aws_iam_policy_document" "aws_cloudtrail_logs" {
  statement {
    sid       = "AWSCloudTrailAclCheck20150319"
    effect    = "Allow"
    resources = ["${aws_s3_bucket.aws_cloudtrail_logs.arn}"]
    actions   = ["s3:GetBucketAcl"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    sid       = "AWSCloudTrailWrite20150319"
    effect    = "Allow"
    resources = ["${aws_s3_bucket.aws_cloudtrail_logs.arn}/AWSLogs/979370138172/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket_policy" "aws_cloudtrail_logs" {
  bucket = aws_s3_bucket.aws_cloudtrail_logs.id
  policy = data.aws_iam_policy_document.aws_cloudtrail_logs.json
}

