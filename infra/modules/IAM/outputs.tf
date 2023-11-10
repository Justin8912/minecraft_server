output "secret" {
  value = aws_iam_access_key.minecraft-server.encrypted_secret
}

// Output a handle to the iam role for the ec2 instance to use
output "minecraft-iam-role-name" {
  value = aws_iam_role.minecraft-iam-role-access.name
}