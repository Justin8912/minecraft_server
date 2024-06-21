variable "app-name" {}
variable "ec2_instance" {
  type = object({
    id: string,
    arn: string
  })
}