# Variables
variable "access_key" {
  sensitive = true
  type      = string
}
variable "secret_key" {
  sensitive = true
  type      = string
}
variable "aws_region" {
  type    = string
  default = "<%=customOptions.awsRegion%>"
}
variable "count_of_workers" {
  default = "<%=customOptions.count_workers%>"
}
variable "public_key" {
  sensitive = true
  type      = string
  default   = "value_from_tfvars"
}
