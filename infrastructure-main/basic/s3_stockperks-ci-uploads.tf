#S3 bucket stockperks-ci-uploads
resource "aws_s3_bucket" "stockperks_ci_uploads" {
  bucket = "stockperks-ci-uploads"
}

data "aws_iam_policy_document" "stockperks_ci_uploads_policy_document" {
  statement {
    resources = ["${aws_s3_bucket.stockperks_ci_uploads.arn}/*"]
    actions   = ["s3:*"]
    effect    = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::979370138172:root"]
    }
  }
}

resource "aws_s3_bucket_policy" "stockperks_ci_uploads_policy" {
  bucket = aws_s3_bucket.stockperks_ci_uploads.id
  policy = data.aws_iam_policy_document.stockperks_ci_uploads_policy_document.json
}

resource "aws_s3_bucket_acl" "stockperks_ci_uploads_acl" {
  bucket = aws_s3_bucket.stockperks_ci_uploads.id
  access_control_policy {
    grant {
      grantee {
        id   = data.aws_canonical_user_id.current.id
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }
    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}
