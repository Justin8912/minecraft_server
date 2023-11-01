resource "aws_security_group" "allow_most_traffic" {
  name        = "allow_most_traffic"
  description = "Allow SSH, HTTPS, and HTTP"

  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    description      = "Allow HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    description      = "Allow HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    description      = "Allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "UDP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    description      = "Allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "UDP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    description      = "Allow Minecraft Traffic"
    from_port        = 25565
    to_port          = 25565
    protocol         = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    description      = "Allow Minecraft Traffic"
    from_port        = 25565
    to_port          = 25565
    protocol         = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }


  tags = {
    Name = "allow_most_traffic"
  }
}