# Recurso que define o Application Load Balancer (ALB)
resource "aws_lb" "wordpress_alb" {
  # Nome do Load Balancer
  name = "wordpress-load-balancer"

  # Indica se o Load Balancer é interno (somente acessível dentro da VPC) ou externo (acessível da Internet)
  internal = false

  # Tipo do Load Balancer, definido como "application" para Application Load Balancer
  load_balancer_type = "application"

  # Grupos de segurança associados ao Load Balancer. Esse SG deve permitir tráfego HTTP (porta 80)
  security_groups = [aws_security_group.sc-ec2-wordpress.id]

  # Subnets em que o Load Balancer será criado, deve estar em subnets públicas para ser acessível
  subnets = [aws_subnet.subnet-public-1a.id, aws_subnet.subnet-public-1b.id]
}

# Listener do Load Balancer que escuta na porta 80 (HTTP)
resource "aws_lb_listener" "this" {
  # Referência ao ARN do Load Balancer criado anteriormente
  load_balancer_arn = aws_lb.wordpress_alb.arn

  # Porta na qual o listener vai escutar (HTTP usa a porta 80)
  port = "80"

  # Protocolo usado para o listener (neste caso, HTTP)
  protocol = "HTTP"

  # Ação padrão quando uma requisição é recebida: encaminhar (forward) para o Target Group
  default_action {
    # Tipo de ação que será tomada: forward, ou seja, encaminhar o tráfego
    type = "forward"

    # O ARN do Target Group para o qual o tráfego será encaminhado
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# Definição do Target Group, que agrupa as instâncias que irão receber tráfego do Load Balancer
resource "aws_lb_target_group" "this" {
  # Nome do Target Group
  name = "learn-asg-terramino"

  # Porta na qual o Target Group vai receber tráfego (HTTP na porta 80)
  port = 80

  # Protocolo usado para comunicação (HTTP)
  protocol = "HTTP"

  # VPC onde o Target Group será criado (deve corresponder à VPC das instâncias)
  vpc_id = aws_vpc.mainvpc.id

  # Configurações de health check para garantir que as instâncias estão funcionando
  health_check {
    # Caminho a ser verificado para o health check (raiz do servidor, "/")
    path = "/"

    # Porta usada pelo health check (mesma da aplicação, 80)
    port = 80

    # Protocolo usado para o health check
    protocol = "HTTP"

    # Número de verificações consecutivas necessárias para considerar a instância saudável
    healthy_threshold = 3

    # Número de verificações consecutivas antes de considerar a instância não saudável
    unhealthy_threshold = 3

    # Códigos HTTP considerados válidos para o health check (de 200 a 499)
    matcher = "200-499"
  }
}

# Associa o Auto Scaling Group (ASG) ao Target Group do Load Balancer
resource "aws_autoscaling_attachment" "this" {
  # Nome do Auto Scaling Group que será associado ao Target Group
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name

  # ARN do Target Group para onde o tráfego será direcionado
  lb_target_group_arn = aws_lb_target_group.this.arn
}


/*Explicação Geral:
Load Balancer: Define um Application Load Balancer (ALB) que distribui o tráfego para suas instâncias EC2. Ele é configurado para ser acessível externamente (porta 80) e associado a subnets públicas.
Listener: É responsável por escutar na porta 80 (HTTP) e direcionar o tráfego para o grupo de destinos (Target Group).
Target Group: Agrupa as instâncias que irão receber o tráfego do Load Balancer. Também contém as configurações de health check, que garantem que as instâncias EC2 estão saudáveis.
Auto Scaling Attachment: Associa um Auto Scaling Group (ASG) ao Target Group para que o tráfego seja distribuído dinamicamente às instâncias gerenciadas pelo ASG, de acordo com a demanda.
Esses comentários ajudam a entender como o tráfego é roteado do ALB para as instâncias, garantindo balanceamento de carga e verificações de saúde para alta disponibilidade.

*/