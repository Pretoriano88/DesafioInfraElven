// Internet gateway 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mainvpc.id


  tags = {
    Name = "IGWmain"
  }
}

# Criar um Elastic IP para o NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# Criar o NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet-public-1b.id # Altere para o ID da sua subnet pública, é necessário usar a subnet pública. A subnet privada não deve ser usada aqui, pois o NAT Gateway precisa de um endereço IP público e, por isso, deve estar em uma subnet que tem acesso à internet.

  tags = {
    Name = "Nat-Gateway"
  }

}

# Criação da tabela de roteamento para as subnets públicas
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.mainvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Rtb-publica"
  }
}


# Associação da tabela de roteamento às subnets públicas
resource "aws_route_table_association" "public_subnet_association_1a" {
  subnet_id      = aws_subnet.subnet-public-1a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_association_1b" {
  subnet_id      = aws_subnet.subnet-public-1b.id
  route_table_id = aws_route_table.public_route_table.id
}


# Criar uma tabela de rotas para a subnet privada
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.mainvpc.id # Altere para o ID do seu VPC

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id # Rota padrão para o NAT Gateway
  }
}

# Associar a tabela de rotas com a subnet privada
resource "aws_route_table_association" "private_route_association" {
  subnet_id      = aws_subnet.subnet-private-2b.id # Esta é a subnet privada
  route_table_id = aws_route_table.private_route_table.id
}
