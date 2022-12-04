#S3 bucket stockperks-infra-tfstate
resource "aws_s3_bucket" "stockperks_infra_tfstate" {
  bucket = "stockperks-infra-tfstate"
}

resource "aws_s3_bucket_public_access_block" "stockperks_infra_tfstate_access_block" {
  bucket = aws_s3_bucket.stockperks_infra_tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "stockperks_infra_tfstate_own" {
  bucket = aws_s3_bucket.stockperks_infra_tfstate.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_acl" "stockperks_infra_tfstate_acl" {
  bucket = aws_s3_bucket.stockperks_infra_tfstate.id
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
