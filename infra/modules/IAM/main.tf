resource "aws_iam_user" "minecraft-server" {
  name = "${var.app-name}-iam-user"
  path = "/IAM/user/"
}

resource "aws_iam_access_key" "minecraft-server" {
  user    = aws_iam_user.minecraft-server.name
}

data "aws_iam_policy_document" "minecraft-server" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:StartSession",
      "ssm:SendCommand"                                                        //For Session manager access from Amazon EC2 console
    ]
    resources = [
      "arn:aws:ec2:us-east-1:597106394031:instance/i-06565eba97092c4ba",
      "arn:aws:ssm:*::document/AWS-StartPortForwardingSession"                //For Session Manager Port Forwarding Feature
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ssm:DescribeSessions",
      "ssm:GetConnectionStatus",
      "ssm:DescribeInstanceInformation",
      "ssm:DescribeInstanceProperties",
      "ec2:DescribeInstances"
    ]
    resources= ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:TerminateSession",
      "ssm:ResumeSession"
    ]
    resources = [
      "arn:aws:ssm:*:*:session/minecraft-server-iam-user-*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:*"
    ]
    resources = [
      "arn:aws:iam::597106394031:role/minecraft-server-role"
    ]
  }
}

resource "aws_iam_user_policy" "minecraft-server" {
  name   = "${var.app-name}-iam-user"
  user   = aws_iam_user.minecraft-server.name
  policy = data.aws_iam_policy_document.minecraft-server.json
}

resource "aws_iam_role" "minecraft-iam-role-access" {
  name               = "minecraft-iam-role-access"
  description        = "The role used to link an IAM user to access the server"
  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": {
        "Effect": "Allow",
        "Principal": {"Service": "ec2.amazonaws.com"},
        "Action": "sts:AssumeRole"
      }
    }
    EOF
}


resource "aws_iam_role_policy_attachment" "dev-resources-ssm-policy" {
  role       = aws_iam_role.minecraft-iam-role-access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}