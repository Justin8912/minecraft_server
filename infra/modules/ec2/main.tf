data "aws_ami" "ubutnu" {
    most_recent = "true"


}

resource "aws_instance" {
    ami = data.aws_ami.ubuntu.id

    instance_type="m5.large"

    root_block_device {
        volume_size = "25GiB"
    }

    lifecycle {
        replace_triggered_by=[aws_security_group.allow_all_traffic]
    }
}