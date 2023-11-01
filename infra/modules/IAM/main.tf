resource "aws_iam_user" "minecraft-server" {
  name = "${var.app-name}-iam-user"
  path = "/system/"
}

resource "aws_iam_access_key" "minecraft-server" {
  user    = aws_iam_user.minecraft-server.name
  pgp_key = "keybase:minecraft-server"
}

data "aws_iam_policy_document" "minecraft-server" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "minecraft-server" {
  name   = "test"
  user   = aws_iam_user.minecraft-server.name
  policy = data.aws_iam_policy_document.minecraft-server.json
}
