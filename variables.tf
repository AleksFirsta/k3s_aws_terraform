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
}
variable "public_key" {
  type      = string
  sensitive = true
  default   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6x7h7o3EPK69qYFJOWFd8B3WsfuzLmtLwpBk42US2A+fXhFs+vBEFReLQ6Hy1/nsdlfDpVs92DO3k/YFGDQbuCNvHWrHzGJpP3ynLho9LqGW3TVxRBCSQALnaE8d6qwUya807p3K3uCHciYeh2RtPLkwKdrwsEGzl8sNt2Drc/OLs3zWsYCQ1X7RI5b2nVon5h27CVHcO2UqQzL7GSf24kKtHUP3ZzaSd16oPW1kHYT/k5ohHkvH97AHLwn4DV/mEaloviD68eq7y90F+BZKbYbCJPnuf78fJqqU2PWxt2CJeNkZ/TaL82ITx3YNSCXFqsAZxmjSSgu8gTwtT34oP"
}
variable "count_of_workers" {
  type    = number
  default = 1
}