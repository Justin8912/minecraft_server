resource "aws_apigatewayv2_api" "lambda_executor" {
  name = "Handle-MC-Server"
  description = "This handles the minecraft server standup or tear down. The only point is to invoke a lambda which will directly communicate with the EC2 instance."
  protocol_type = "HTTP"

}

resource "aws_apigatewayv2_route" "post_route" {
  api_id = aws_apigatewayv2_api.lambda_executor.id
  route_key = "POST /manage-server"
  target = "integrations/${aws_apigatewayv2_integration.integration.id}"
}

resource "aws_apigatewayv2_route" "get_route" {
  api_id = aws_apigatewayv2_api.lambda_executor.id
  route_key = "GET /server-status"
  target = "integrations/${aws_apigatewayv2_integration.integration.id}"
}

resource "aws_apigatewayv2_integration" "integration" {
  api_id = aws_apigatewayv2_api.lambda_executor.id
  integration_type = "AWS_PROXY"
  integration_uri = var.server_starter_lambda.invoke_arn
}

resource "aws_apigatewayv2_stage" "staging" {
  api_id = aws_apigatewayv2_api.lambda_executor.id
  name   = "default-stage"
  auto_deploy = true
}

resource "aws_lambda_permission" "allow_lambda_executions" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.server_starter_lambda.name
  principal     = "apigateway.amazonaws.com"
}