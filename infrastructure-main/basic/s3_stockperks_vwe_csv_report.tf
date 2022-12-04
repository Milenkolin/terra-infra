resource "aws_s3_bucket" "vwe_csv_report" {
  provider = aws.west
  bucket   = "vwe-csv-report"
}

resource "aws_s3_bucket_versioning" "vwe_csv_report" {
  provider = aws.west
  bucket   = aws_s3_bucket.vwe_csv_report.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "vwe_csv_report" {
  provider                = aws.west
  bucket                  = aws_s3_bucket.vwe_csv_report.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "vwe_csv_report" {
  provider = aws.west
  bucket   = aws_s3_bucket.vwe_csv_report.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

data "aws_iam_policy_document" "vwe_csv_report" {
  statement {
    sid       = "S3PolicyStmt-DO-NOT-MODIFY-1641477987224"
    effect    = "Allow"
    resources = ["arn:aws:s3:::vwe-csv-report/*"]

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

resource "aws_s3_bucket_policy" "vwe_csv_report" {
  provider = aws.west
  bucket   = aws_s3_bucket.vwe_csv_report.id
  policy   = data.aws_iam_policy_document.vwe_csv_report.json
}

resource "aws_s3_bucket_acl" "vwe_csv_report" {
  provider = aws.west
  bucket   = aws_s3_bucket.vwe_csv_report.bucket

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
