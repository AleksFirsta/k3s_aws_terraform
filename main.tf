# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "K3s VPC"
  }
}
# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}
# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "Private Subnet"
  }
}
# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "K3s Internet Gateway"
  }
}
# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "NAT Gateway EIP"
  }
}
# NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "K3s NAT Gateway"
  }

  depends_on = [aws_internet_gateway.gw]
}
# Route Table (Public)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}
# Route Table (Private)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "Private Route Table"
  }
}
# Route Table Association (Public)
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
# Route Table Association (Private)
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
# Security Group (NGINX)
resource "aws_security_group" "nginx" {
  name        = "NGINX Security Group"
  description = "Allow inbound HTTP/HTTPS traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "NGINX Security Group"
  }
}
# Security Group (K3s Cluster)
resource "aws_security_group" "k3s" {
  name        = "K3s Security Group"
  description = "Allow inbound traffic for K3s cluster"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "K3s Security Group"
  }
}
#195 from origin
resource "aws_key_pair" "k3s_key" {
  key_name   = "k3s-key"
  public_key = var.public_key
}
# NGINX Load Balancer Instance
resource "aws_instance" "nginx" {
  ami           = data.aws_ami.ubuntu_24_04.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = aws_key_pair.k3s_key.key_name

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.nginx.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              USERNAME=<%= morpheus.user.linuxUsername%>
              SSH_KEY="${aws_key_pair.k3s_key.public_key}"
              sudo useradd -m -s /bin/bash $USERNAME
              echo "$USERNAME:P@ssw0rd3#" | sudo chpasswd
              sudo usermod -aG sudo $USERNAME
              sudo -u $USERNAME mkdir -p /home/$USERNAME/.ssh
              sudo -u $USERNAME chmod 700 /home/$USERNAME/.ssh
              echo "$SSH_KEY" | sudo -u $USERNAME tee /home/$USERNAME/.ssh/authorized_keys > /dev/null
              sudo -u $USERNAME chmod 600 /home/$USERNAME/.ssh/authorized_keys
              apt-get install -y nginx
              # Create a simple HTML page
              cat > /var/www/html/index.html <<'EOL'
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Welcome to K3s Cluster Orchestration</title>
                  <style>
                      body {
                          font-family: Arial, sans-serif;
                          margin: 40px auto;
                          max-width: 650px;
                          line-height: 1.6;
                          padding: 0 10px;
                      }
                  </style>
              </head>
              <body>
                  <h1>Welcome to K3s Cluster Orchestration</h1>
                  <h1>AWS Infrastructure Automation with Terraform Blueprint</h1>
              </body>
              </html>
              EOL

              # Configure NGINX
              cat > /etc/nginx/sites-available/default <<'EOL'
              server {
                  listen 80 default_server;
                  listen [::]:80 default_server;
                  
                  root /var/www/html;
                  index index.html index.htm;

                  server_name _;

                  location / {
                      try_files $uri $uri/ =404;
                  }
              }
              EOL

              systemctl restart nginx
              EOF

  tags = {
    Name = "NGINX Load Balancer"
  }

  depends_on = [aws_internet_gateway.gw]
}
data "template_file" "user_data" {
  template = file("./user_data.sh")

  vars = {
    master_ip = aws_instance.k3s_master.private_ip
  }
}
# K3s Master Node
resource "aws_instance" "k3s_master" {
  ami           = data.aws_ami.ubuntu_24_04.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private.id
  #key_name      = aws_key_pair.k3s_key.key_name

  vpc_security_group_ids = [aws_security_group.k3s.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              sudo useradd -m -s /bin/bash <%= morpheus.user.linuxUsername%>
              echo "<%= morpheus.user.linuxUsername%>:P@ssw0rd3#" | sudo chpasswd
              sudo usermod -aG sudo <%= morpheus.user.linuxUsername%>
              apt-get install -y curl
              curl -sfL https://get.k3s.io | sh -
              EOF

  tags = {
    Name = "K3s Master Node"
  }

  depends_on = [aws_nat_gateway.main]
}
# K3s Worker Nodes
resource "aws_instance" "k3s_workers" {
  count         = var.count_of_workers
  ami           = data.aws_ami.ubuntu_24_04.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private.id
  #key_name      = aws_key_pair.k3s_key.key_name

  vpc_security_group_ids = [aws_security_group.k3s.id]

  user_data = data.template_file.user_data.rendered

  tags = {
    Name = "K3s Worker Node ${count.index + 1}"
  }

  depends_on = [aws_nat_gateway.main]
}