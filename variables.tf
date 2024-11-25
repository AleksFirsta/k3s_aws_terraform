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

variable "morpheus_url" {
  type    = string
  default = "https://morpheus.aruba.lab"
}
variable "morpheus_access_token" {
  type      = string
  sensitive = true
  default   = "value_from_tfvars"
}