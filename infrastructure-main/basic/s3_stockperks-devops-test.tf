#S3 bucket stockperks-devops-test
resource "aws_s3_bucket" "stockperks_devops_test" {
  bucket = "stockperks-devops-test"
}

resource "aws_s3_bucket_public_access_block" "stockperks_devops_test_access_block" {
  bucket = aws_s3_bucket.stockperks_devops_test.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_acl" "stockperks_devops_test_acl" {
  bucket = aws_s3_bucket.stockperks_devops_test.id
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
