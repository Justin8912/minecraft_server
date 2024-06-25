output "lambda" {
  value = {
    id: aws_lambda_function.minecraft-invoker.id,
    arn: aws_lambda_function.minecraft-invoker.arn,
    name: aws_lambda_function.minecraft-invoker.function_name,
    invoke_arn: aws_lambda_function.minecraft-invoker.invoke_arn
  }
}