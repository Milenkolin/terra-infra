#S3 bucket stockperks-api-uploads
resource "aws_s3_bucket" "stockperks_api_uploads" {
  provider = aws.west
  bucket   = "stockperks-api-uploads"
}

resource "aws_s3_bucket_acl" "stockperks_api_uploads_acl" {
  provider = aws.west
  bucket   = aws_s3_bucket.stockperks_api_uploads.id
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
