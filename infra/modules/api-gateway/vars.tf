variable "server_starter_lambda" {
  type = object({
    name: string,
    arn: string,
    id: string,
    invoke_arn: string
  })
}