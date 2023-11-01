output "secret" {
  value = aws_iam_access_key.minecraft-server.encrypted_secret
}