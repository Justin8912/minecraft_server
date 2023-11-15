output "secret" {
  value = aws_iam_access_key.minecraft-server.encrypted_secret
}

output "minecraft-iam-role-name" {
  value = aws_iam_role.minecraft-iam-role-access.name
}

output "minecraft-iam-role-arn" {
  value = aws_iam_role.minecraft-iam-role-access.arn
}