resource "morpheus_ansible_playbook_task" "k3sconfig" {
  name            = "config_k3s_cluster_aws"
  code            = "configk3s"
  ansible_repo_id = data.morpheus_integration.ansible_repo.id
  playbook        = "k3sconfig"
  command_options = "-o ProxyJump=ubuntu@${aws_instance.k3s_master.public_ip}"
  execute_target  = "server"
}