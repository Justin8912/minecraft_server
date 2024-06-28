variable "ec2_instance" {
  type= object({
    arn: string,
    id: string
  })
}