#!/bin/bash
apt-get update
apt-get install -y curl
MASTER_IP="${master_ip}"
TOKEN=$(ssh -o StrictHostKeyChecking=no ubuntu@${MASTER_IP} -t "sudo cat /var/lib/rancher/k3s/server/node-token")
curl -sfL https://get.k3s.io | K3S_URL=https://$MASTER_IP:6443 K3S_TOKEN=$TOKEN sh -
