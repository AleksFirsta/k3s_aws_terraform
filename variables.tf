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
  type    = number
  default = 1 #Заменить на опцию из морфиуса и добавить в tfvars 
}
variable "public_key" {
  sensitive = true
  type      = string
  default   = "value"
}
