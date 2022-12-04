resource "aws_s3_bucket" "cf_templates" {
  bucket = "cf-templates-1rfokqwz8mfdm-us-east-1"
}



resource "aws_s3_bucket_acl" "cf_templates" {
  bucket = aws_s3_bucket.cf_templates.bucket
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

resource "aws_s3_bucket_server_side_encryption_configuration" "cf_templates" {
  bucket = aws_s3_bucket.cf_templates.bucket

  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#resource "aws_s3_bucket_public_access_block" "cf_templates" {
#  bucket = aws_s3_bucket.cf_templates.id
#
#  block_public_acls       = false
#  block_public_policy     = false
#  ignore_public_acls      = true
#  restrict_public_buckets = false
#}
