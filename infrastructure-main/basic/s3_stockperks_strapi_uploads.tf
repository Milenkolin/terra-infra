resource "aws_s3_bucket" "stockperks_strapi_uploads" {
  bucket = "stockperks-strapi-uploads"
}

resource "aws_s3_bucket_versioning" "stockperks_strapi_uploads" {
  bucket = aws_s3_bucket.stockperks_strapi_uploads.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "stockperks_strapi_uploads" {
  bucket                  = aws_s3_bucket.stockperks_strapi_uploads.id
  block_public_acls       = false
  block_public_policy     = true
  ignore_public_acls      = false
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "stockperks_strapi_uploads" {
  bucket = aws_s3_bucket.stockperks_strapi_uploads.bucket

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
