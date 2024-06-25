#resource "aws_iam_role" "iam_for_apigw" {
#  name               = "apigw-iam-role-mc-server"
#  assume_role_policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Sid": "",
#      "Effect": "Allow",
#      "Principal": {
#        "Service": [
#          "apigateway.amazonaws.com"
#        ]
#      },
#      "Action": "sts:AssumeRole"
#    }
#  ]
#}
#EOF
#}
#
#resource "aws_iam_policy_attachment" "apigw_permissions" {
#  name = "IAM policy attachment from the lambda policy defined."
#  role = aws_iam_role.iam_for_apigw
#  policy_arn = aws_iam_policy.policy.arn
#}
#
#resource "aws_iam_policy" "policy" {
#  name = "api_gw_lambda_invoker_permission"
#  path = "/"
#  description = "Allow APIGW to invoke lambda function ${var.server_starter_lambda.name}"
#  policy = data.aws_iam_policy_document.permission_doc.json
#}
#
#data "aws_iam_policy_document" "permission_doc" {
#  statement {
#    effect = "Allow"
#
#    actions = [
#      "lambda:InvokeFunction"
#    ]
#
#    resources = [var.server_starter_lambda.arn]
#  }
#}