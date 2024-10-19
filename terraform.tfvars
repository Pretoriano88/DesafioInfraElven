// Região da AWS e VPC
region       = "us-east-1"        # Região onde os recursos serão criados
vpc_cidr     = "10.0.0.0/16"      # Bloco CIDR da VPC

public_onlaunch = true            # Definir se instâncias EC2 recebem IP público

// Variáveis das EC2
ami_image     = "ami-07d9b9ddc6cd8dd30"  # ID da AMI usada nas instâncias EC2
type_instance = "t2.medium"              # Tipo da instância EC2

// Variáveis do RDS
allo_stora           = 10                # Espaço de armazenamento alocado (em GB)
dbname               = "bdwordpress"     # Nome do banco de dados
engine               = "mysql"           # Engine do banco de dados
v_engine             = "8.0"             # Versão da engine do banco
classinstance        = "db.t3.micro"     # Classe da instância RDS
user                 = "elfos"           # Nome de usuário do banco de dados
password             = "elfos123"        # Senha do banco de dados
parameter_group_name = "default.mysql8.0" # Grupo de parâmetros do RDS
port                 = 3306              # Porta usada pelo banco de dados

// Protocolo e email de notificação (caso usado SNS)
protocolo  = "email"                     # Protocolo de notificação (email por padrão)
email      = "joaopaulo_jp88@hotmail.com" # E-mail para receber notificações

// Variáveis do EFS
efs_mount_point = "/var/www/html/wp-content/uploads"  # Ponto de montagem do EFS nas EC2

myIp = "177.30.71.32"