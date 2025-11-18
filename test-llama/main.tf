provider "aws" {
  region = "ap-northeast-2"
}

# VPC
resource "aws_vpc" "llm_vpc" {
  cidr_block = "10.10.0.0/16"
}

resource "aws_subnet" "llm_subnet" {
  vpc_id                  = aws_vpc.llm_vpc.id
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "llm_igw" {
  vpc_id = aws_vpc.llm_vpc.id
}

resource "aws_route_table" "llm_rt" {
  vpc_id = aws_vpc.llm_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.llm_igw.id
  }
}

resource "aws_route_table_association" "llm_rt_assoc" {
  route_table_id = aws_route_table.llm_rt.id
  subnet_id      = aws_subnet.llm_subnet.id
}

# SG
resource "aws_security_group" "llm_sg" {
  name        = "llama2-gpu-sg"
  vpc_id      = aws_vpc.llm_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "llm_key" {
  key_name   = "llm-key"
  public_key = file("~/.ssh/llama2_key.pub")
}

# IAM
resource "aws_iam_role" "ec2_role" {
  name = "llama2_gpu_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"

  depends_on = [aws_iam_role.ec2_role]
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"

  depends_on = [aws_iam_role.ec2_role]
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "llama2_gpu_ec2_profile"
  role = aws_iam_role.ec2_role.name

  depends_on = [aws_iam_role.ec2_role]
}

# USER DATA
locals {
  user_data = <<EOF
#!/bin/bash
set -eux

apt-get update -y
apt-get install -y docker.io awscli

systemctl enable docker
systemctl start docker

# NVIDIA Container Toolkit
distribution=$(. /etc/os-release; echo $ID$VERSION_ID)
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list \
  | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
  | tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

apt-get update -y
apt-get install -y nvidia-container-toolkit
nvidia-ctk runtime configure --runtime=docker

systemctl restart docker


EOF
}

# EC2
resource "aws_instance" "llm_gpu" {
  ami                         = "ami-07cfba2a1601b3d6e" # Deep Learning Base AMI (GPU)
  instance_type               = "g5.xlarge"
  subnet_id                   = aws_subnet.llm_subnet.id
  vpc_security_group_ids      = [aws_security_group.llm_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true
  key_name = aws_key_pair.llm_key.key_name
  user_data = local.user_data
  
  tags = {
    Name = "llama2-gpu-server"
  }
}
