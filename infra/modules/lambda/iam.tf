// Iam role - this is what is attached directly to the resource
//   (in this case the lambda)
resource "aws_iam_role" "iam_for_lambda" {
  name               = "${local.lambda_function_name}-iam-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

// Policy attachments - these attach policies to the lambdas
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging_permissions.arn
}

resource "aws_iam_role_policy_attachment" "lambda_ec2" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_ec2_permissions.arn
}

// Policy - these contain the policy documents (list of permissions)
//   that the role will eventually will assume.
resource "aws_iam_policy" "lambda_logging_permissions" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy logging from ${local.lambda_function_name}"
  policy      = data.aws_iam_policy_document.logging_permissions.json
}

resource "aws_iam_policy" "lambda_ec2_permissions" {
  name        = "lambda_ec2"
  path        = "/"
  description = "IAM policy logging from ${local.lambda_function_name}"
  policy      = data.aws_iam_policy_document.ec2_permissions.json
}

// policy documents - this is where the permissions are actually defined
data "aws_iam_policy_document" "role_attachment" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    resources = ["lambda.amazonaws.com"]
  }
}

data "aws_iam_policy_document" "ec2_permissions" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:RunInstances"
    ]

    resources = [var.instance.arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:DescribeInstances"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "logging_permissions" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}