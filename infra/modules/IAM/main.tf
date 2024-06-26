resource "aws_iam_user" "minecraft-server" {
  name = "${var.app-name}-iam-user"
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
      var.ec2_instance.arn,
      "arn:aws:ssm:*::document/AWS-StartPortForwardingSession",             //For Session Manager Port Forwarding Feature
      "arn:aws:ssm:us-east-1::document/AWS-RunShellScript"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ssm:DescribeSessions",
      "ssm:GetConnectionStatus",
      "ssm:DescribeInstanceInformation",
      "ssm:DescribeInstanceProperties",
      "ssm:GetCommandInvocation",
      "ec2:DescribeInstanceStatus",
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
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:DescribeInstances"
    ]
    resources = [
      var.ec2_instance.arn,
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