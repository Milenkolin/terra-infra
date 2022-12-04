resource "aws_s3_bucket" "stockperks_secured" {
  bucket = "stockperks-secured"
}

resource "aws_s3_bucket_versioning" "stockperks_secured" {
  bucket = aws_s3_bucket.stockperks_secured.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "stockperks_secured" {
  bucket = aws_s3_bucket.stockperks_secured.bucket

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      kms_master_key_id = "arn:aws:kms:us-east-1:979370138172:key/267964b0-6505-4293-9757-6f5cf3c7fb9e"
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "stockperks_secured" {
  bucket                  = aws_s3_bucket.stockperks_secured.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "stockperks_secured" {
  bucket = aws_s3_bucket.stockperks_secured.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

data "aws_iam_policy_document" "stockperks_secured" {
  statement {
    effect    = "Allow"
    resources = ["arn:aws:s3:::stockperks-secured/*"]

    actions = [
      "s3:PutObjectAcl",
      "s3:PutObject",
      "s3:GetObjectAcl",
      "s3:GetObject",
      "s3:DeleteObject"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::979370138172:root"]
    }
  }

  statement {
    sid       = "DenyIncorrectEncryptionHeader"
    effect    = "Deny"
    resources = ["arn:aws:s3:::stockperks-secured/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  statement {
    sid       = "DenyUnencryptedObjectUploads"
    effect    = "Deny"
    resources = ["arn:aws:s3:::stockperks-secured/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["true"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "stockperks_secured" {
  bucket = aws_s3_bucket.stockperks_secured.id
  policy = data.aws_iam_policy_document.stockperks_secured.json
}

resource "aws_s3_bucket_acl" "stockperks_secured" {
  bucket = aws_s3_bucket.stockperks_secured.bucket

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
