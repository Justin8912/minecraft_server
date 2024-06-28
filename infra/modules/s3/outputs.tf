output "s3_saves" {
  value = {
    name = aws_s3_bucket.minecraft_saves.bucket,
    id   = aws_s3_bucket.minecraft_saves.id,
    arn  = aws_s3_bucket.minecraft_saves.arn
  }
}