data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_key_pair" "connection" {
  key_name   = "connection-key"
  public_key = var.public-connection-key
}

resource "aws_iam_instance_profile" "minecraft-profile" {
  name = "minecraft-profile"
  role = var.minecraft-iam-role-name
}

resource "aws_instance" "test-server" {
  ami = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "m5.large"

  root_block_device {
    delete_on_termination = false
    volume_size = 20
    volume_type = "standard"
  }

  tags = {
    name = var.app_name
  }

  key_name = aws_key_pair.connection.key_name

  security_groups = [aws_security_group.allow_most_traffic.name]
  iam_instance_profile = aws_iam_instance_profile.minecraft-profile.name
}