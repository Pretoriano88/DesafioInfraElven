resource "aws_security_group" "efs_sg" {
  name        = "efs-security-group"
  description = "Security group for EFS"
  vpc_id      = aws_vpc.mainvpc.id


  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Permitir todo o tráfego de saída
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Efs-sg"
  }
}


# Security group EC2
resource "aws_security_group" "sc-ec2-wordpress" {
  name        = "pemitir ssh, http for wordpress"
  description = "Allow SSH, HTTP for wordpress"
  vpc_id      = aws_vpc.mainvpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.myIp}/32"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Wordpress-sg"
  }
}

# Security group RDS
resource "aws_security_group" "allow_rds" {
  name        = "allow_rds"
  description = "Allow MySQL traffic from EC2 instances"
  vpc_id      = aws_vpc.mainvpc.id

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [
      aws_subnet.subnet-public-1a.cidr_block,
      aws_subnet.subnet-public-1b.cidr_block
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Rds-sg"
  }
}

resource "aws_security_group" "pritunl_sg" {
  name        = "pritunl-sg"
  description = "Security group for Pritunl VPN Server"
  vpc_id      = aws_vpc.mainvpc.id

  # Porta de gerenciamento do Pritunl (default: 443 para gerenciamento via web)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.myIp}/32"]
  }

  # Porta de VPN Pritunl
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH para administração
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.myIp}/32"]

  }

  # Regras de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Pritunl sg"
  }
}
resource "aws_security_group" "sg_docker" {
  name        = "sg_docke allow http 8080"
  description = "Allow HTTP traffic for container acces"
  vpc_id      = aws_vpc.mainvpc.id # Assumindo que já tenha o ID da VPC em que a EC2 está

  # Regra para permitir o tráfego HTTP na porta 8080
  ingress {
    description = "Permitir HTTP na porta 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Permitir HTTP na porta 8080"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.mainvpc.cidr_block]
  }

  # Regras para saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Permitir qualquer tráfego de saída
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Docker-sg"
  }
}

resource "aws_security_group" "sg_elastic-cache" {
  name        = "memcached"
  description = "Security group for Memcached"
  vpc_id      = aws_vpc.mainvpc.id

  // Regras de entrada
  ingress {
    description = "Allow inbound traffic from EC2 instances"
    from_port   = 11211 # Porta do Memcached
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Regras de saída (outbound)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Memcached-sg"
  }
}