resource "aws_lambda_function" "minecraft-invoker" {
  function_name = local.lambda_function_name
  role          = var.minecraft-server-iam-role-arn

  filename      = "../../../lambda-code/target/lambda-code-1.jar"
  source_code_hash = filebase64sha256("${path.root}/../../../lambda-code/target/lambda-code-1.jar")

  handler       = local.lambda_handler
}