variable "access_key" {
  type      = string
  sensitive = true
}
variable "secret_key" {
  type      = string
  sensitive = true
}
variable "aws_region" {
  type      = string
  sensitive = false
  default   = "<%=customOptions.awsRegion%>"
}
variable "public_key" {
  type      = string
  sensitive = true
  default   = "<%= cypher.read('password/public_key') %>"
}
variable "count_of_workers" {
  type    = number
  default = 1
}