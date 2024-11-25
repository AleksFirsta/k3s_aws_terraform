data "morpheus_key_pair" "wsl_aleks_vm" {
  name = "wsl_aleks_vm"
}
data "morpheus_integration" "ansible_repo" {
  name = "Ansible automation"
}