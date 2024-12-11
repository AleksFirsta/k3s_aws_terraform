resource "morpheus_ansible_playbook_task" "k3sconfig" {
  name            = "config_k3s_cluster_aws"
  code            = "configk3s"
  ansible_repo_id = data.morpheus_integration.ansible_repo.id
  playbook        = "k3sconfig"
  command_options = "-v"
  execute_target  = "local"
  depends_on      = [aws_instance.nginx]
}

# пример без использования инвентаря
# ansible-playbook -i "web1,web2," playbook.yml \
#   --user remoteuser \
#   --private-key ~/.ssh/remote_key \
#   --ssh-common-args='-o ProxyJump=jumpuser@192.168.1.100'