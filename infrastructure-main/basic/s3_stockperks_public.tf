resource "aws_s3_bucket" "stockperks_public" {
  provider = aws.us-east-2
  bucket   = "s3-stockperks-public.com"
}

resource "aws_s3_bucket_acl" "stockperks_public" {
  bucket   = aws_s3_bucket.stockperks_public.id
  provider = aws.us-east-2
}

#resource "aws_s3_bucket_public_access_block" "stockperks_public" {
#  bucket                  = aws_s3_bucket.stockperks_public.id
#  provider                = aws.us-east-2
#  block_public_acls       = false
#  block_public_policy     = false
#  ignore_public_acls      = true
#  restrict_public_buckets = false
#}
