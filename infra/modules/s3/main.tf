resource "aws_s3_bucket" "minecraft_saves" {
  bucket = local.bucket_name
}

resource "aws_s3_bucket_lifecycle_configuration" "allow_versioning_keep_last_two" {
  bucket = aws_s3_bucket.minecraft_saves.id

  rule {
    id = "1"

    noncurrent_version_expiration {
      noncurrent_days = 1  # Keep noncurrent versions for 1 day
    }
    transition {
      days          = 30  # Transition to S3 Standard-IA storage after 30 days
      storage_class = "STANDARD_IA"
    }
    expiration {
      days = 365  # Permanently delete versions older than 365 days
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.minecraft_saves.id

  versioning_configuration {
    status = "Enabled"
  }
}