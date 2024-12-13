resource "morpheus_ansible_playbook_task" "k3sconfig" {
  name            = "config_k3s_cluster_aws"
  code            = "configk3s"
  ansible_repo_id = data.morpheus_integration.ansible_repo.id
  playbook        = "k3sconfig"
  command_options = "-v"
  execute_target  = "local"
  depends_on      = [aws_instance.nginx]
}

resource "morpheus_key_pair" "k3s_connect_aws"{
  name= "k3s_aws_connect"
  public_key = tls_private_key.k3s_connect_aws.public_key_openssh
  private_key = tls_private_key.k3s_connect_aws.private_key_pem
}
