resource "aws_s3_bucket" "stockperks_terraform" {
  bucket = "stockperks-terraform"
}

resource "aws_s3_bucket_versioning" "stockperks_terraform" {
  bucket = aws_s3_bucket.stockperks_terraform.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "stockperks_terraform" {
  bucket = aws_s3_bucket.stockperks_terraform.bucket

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
