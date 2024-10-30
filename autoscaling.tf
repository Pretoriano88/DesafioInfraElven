# Definição de um grupo de Auto Scaling para as instâncias EC2 que irão rodar o WordPress
resource "aws_autoscaling_group" "wordpress_asg" {
  # Quantidade desejada de instâncias em execução
  desired_capacity = 2

  # Número máximo de instâncias que o grupo de Auto Scaling pode escalar
  max_size = 4

  # Número mínimo de instâncias que devem sempre estar em execução
  min_size = 2

  # Identificadores das subnets onde as instâncias serão lançadas, deve ser em subnets públicas para permitir acesso externo
  vpc_zone_identifier = [aws_subnet.subnet-public-1a.id, aws_subnet.subnet-public-1b.id]

  # Template de lançamento que define a configuração de instâncias EC2
  launch_template {
    # ID do template de lançamento (referenciado abaixo)
    id = aws_launch_template.wordpress_lt.id

    # Utiliza a versão mais recente do template de lançamento
    version = "$Latest"
  }

  # Tags que serão aplicadas às instâncias EC2 geradas pelo Auto Scaling
  tag {
    key                 = "Name"
    value               = local.instance_name # Usando uma variável local para definir o nome da instância
    propagate_at_launch = true                # Propaga essa tag no momento do lançamento da instância
  }

  # Tag para o ambiente das instâncias (produção)
  tag {
    key                 = "Environment"
    value               = "Production"
    propagate_at_launch = true # Propaga a tag na criação das instâncias
  }

  # Tag para identificar a aplicação rodando nas instâncias
  tag {
    key                 = "Application"
    value               = "WordPress"
    propagate_at_launch = true # Propaga a tag na criação das instâncias
  }
}

# Template de lançamento que especifica a configuração das instâncias EC2 WordPress
resource "aws_launch_template" "wordpress_lt" {
  # Prefixo para o nome do template de lançamento
  name_prefix = "wordpress-lt"

  # ID da AMI (Amazon Machine Image) que será usada para lançar as instâncias
  image_id = var.ami_image # Variável definida pelo usuário para escolher a imagem

  # Tipo da instância EC2 (por exemplo, t2.micro, t3.medium, etc.)
  instance_type = var.type_instance # Variável definida pelo usuário para escolher o tipo de instância

  # Chave SSH para acessar as instâncias
  key_name = aws_key_pair.keypair.key_name # Nome da chave SSH definida em outro recurso

  # Mapeamento de dispositivos de bloco (discos) para as instâncias
  block_device_mappings {
    device_name = "/dev/xvda" # Nome do dispositivo principal (EBS) da instância
    ebs {
      volume_size = 20 # Tamanho do volume EBS (20 GB)
    }
  }

  # Configuração das interfaces de rede das instâncias
  network_interfaces {
    # Associa um endereço IP público às instâncias (necessário para instâncias em subnets públicas)
    associate_public_ip_address = true

    # Grupos de segurança aplicados às interfaces de rede
    security_groups = [aws_security_group.sc-ec2-wordpress.id]
  }

  # Script de inicialização (user_data) que configura o ambiente WordPress nas instâncias
  user_data = base64encode(
    templatefile("ec2Wordpress.sh", {                                                       # Arquivo de script externo que será executado no lançamento da instância
      wp_db_name       = aws_db_instance.bdword.db_name,                                    # Nome do banco de dados do WordPress
      wp_username      = aws_db_instance.bdword.username,                                   # Nome do usuário do banco de dados
      wp_user_password = aws_db_instance.bdword.password,                                   # Senha do usuário do banco de dados
      wp_db_host       = aws_db_instance.bdword.address,                                    # Endereço do banco de dados RDS
      aws_elasticache  = "${aws_elasticache_cluster.cache_cluster.cache_nodes[0].address}", # Endereço do ElastiCache (usado para cache de página)
      efs_dns_name     = "${aws_efs_file_system.file_system_1.dns_name}"                    # Nome DNS do sistema de arquivos EFS compartilhado
    })
  )
}

/*
Explicação Geral:
Auto Scaling Group (aws_autoscaling_group):

Controle de capacidade: Define quantas instâncias EC2 são criadas e escaladas automaticamente, de acordo com a demanda (com tamanho mínimo, desejado e máximo).
Subnets: As instâncias são lançadas em subnets públicas para permitir o acesso da Internet.
Template de lançamento: O template de lançamento (aws_launch_template.wordpress_lt) define os detalhes da configuração de cada instância EC2.
Tags: Cada instância recebe tags específicas, como Name, Environment (produção) e Application (WordPress), para facilitar a identificação e gestão dos recursos.
Launch Template (aws_launch_template):

Imagem e tipo de instância: Especifica a AMI e o tipo de instância EC2 a ser usada.
Chave SSH: Define a chave que será usada para acessar a instância via SSH.
Disco: Mapeia o volume principal da instância (20 GB de EBS).
Rede: Configura a interface de rede, associando um IP público e grupos de segurança que controlam o acesso às instâncias.
User Data: Usa um arquivo de script (ec2Wordpress.sh) que automatiza a configuração do WordPress nas instâncias, conectando-as ao banco de dados RDS, ElastiCache e EFS (sistema de arquivos compartilhado).
*/