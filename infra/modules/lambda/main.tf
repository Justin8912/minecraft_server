resource "aws_lambda_function" "minecraft-invoker" {
  // This lambda is going to need permissions to make updates to EC2 instance.
  function_name = local.lambda_function_name
  role          = aws_iam_role.iam_for_lambda.arn

  filename      = "../../../lambda-code/startServer.zip"
  source_code_hash = filebase64sha256("${path.root}/../../../lambda-code/startServer.zip")

  handler       = local.lambda_handler
  runtime       = "python3.9"

  environment {
    variables = {
      instance_id = var.instance.id
    }
  }

  timeout = 6
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${aws_lambda_function.minecraft-invoker.function_name}"
  retention_in_days = 7
}