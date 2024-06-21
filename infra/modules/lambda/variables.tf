variable "minecraft-server-iam-role-arn" {}
variable "instance" {
  type = object({
    id: string,
    arn: string
  })
}