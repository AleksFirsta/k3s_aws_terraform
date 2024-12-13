# data "morpheus_key_pair" "wsl_aleks_vm" {
#   name = "wsl2404_aleks"
# }
data "morpheus_integration" "ansible_repo" {
  name = "Ansible automation"
}