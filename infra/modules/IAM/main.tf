resource "aws_iam_user" "minecraft-server" {
  name = "${var.app-name}-iam-user"
  path = "/IAM/user/"
}

resource "aws_iam_access_key" "minecraft-server" {
  user    = aws_iam_user.minecraft-server.name
}

data "aws_iam_policy_document" "minecraft-server" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "minecraft-server" {
  name   = "test_iam_user"
  user   = aws_iam_user.minecraft-server.name
  policy = data.aws_iam_policy_document.minecraft-server.json
}

resource "aws_iam_role" "minecraft-iam-role-access" {
  name               = "minecraft-iam-role-access"
  description        = "The role used to link an IAM user to access the server"
  assume_role_policy = data.aws_iam_policy_document.minecraft-iam-role-policy.json

}

data "aws_iam_policy_document" "minecraft-iam-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}