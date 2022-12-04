resource "aws_s3_bucket" "stockperks_alternative" {
  bucket   = "stockperks-alternative"
}

resource "aws_s3_bucket_acl" "stockperks_alternative" {
  bucket   = aws_s3_bucket.stockperks_alternative.id
}

resource "aws_s3_bucket_public_access_block" "stockperks_alternative" {
  bucket                  = aws_s3_bucket.stockperks_alternative.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}