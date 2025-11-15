resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "model_bucket" {
  bucket = "${var.prefix}-model-storage-${random_id.suffix.hex}"
  force_destroy = true

  tags = {
    Name = "${var.prefix}-model-storage"
  }
}

resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket = aws_s3_bucket.model_bucket.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_name" {
  value = aws_s3_bucket.model_bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.model_bucket.arn
}
