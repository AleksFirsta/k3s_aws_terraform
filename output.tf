# Outputs
output "nginx_public_ip" {
  value = aws_instance.nginx.public_ip
}

output "nginx_private_ip" {
  value = aws_instance.nginx.private_ip
}

output "k3s_master_private_ip" {
  value = aws_instance.k3s_master.private_ip
}

output "k3s_worker_private_ips" {
  value = aws_instance.k3s_workers[*].private_ip
}

output "tls_key_public"{
  value = tls_private_key.k3s_connect_aws.public_key_openssh
}

output "tls_private_key"{
  value = tls_private_key.k3s_connect_aws.private_key_pem
  sensitive = true
}