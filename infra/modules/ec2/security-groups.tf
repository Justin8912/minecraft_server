resource "aws_security_group" "allow_all_traffic" {
    name="${locals.app-name}-allow_all_traffic"
    description="For now I want to allow all traffic into this server so that I can be sure that connecting to the minecraft server is successful."

    ingress {
        description      = "HTTPS config"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
    }

    ingress {
        description      = "HTTP config"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
    }

    ingress {
        description      = "SSH connection configuration"
        from_port        = 22
        to_port          = 22
        protocol         = "ssh"
    }

}