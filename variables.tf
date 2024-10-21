// Variáveis gerais do ambiente
variable "region" {
  type        = string
  description = "A região da AWS onde os recursos serão criados"
}

variable "vpc_cidr" {
  type        = string
  description = "Bloco CIDR da VPC"
}

variable "public_onlaunch" {
  type        = bool
  description = "Se as instâncias EC2 terão IP público ao serem lançadas"
}

// Variáveis das instâncias EC2
variable "ami_image" {
  type        = string
  description = "ID da AMI usada para as instâncias EC2"
}

variable "ami_image_pritunl" {
  type = string
  description = "Imagem que o pritunl ira usar  "
  default = "ami-04505e74c0741db8d"
  
}

variable "type_instance" {
  type        = string
  description = "Tipo da instância EC2 (ex: t2.micro, t2.medium, etc.)"
}

// Variáveis do RDS
variable "allo_stora" {
  type        = number
  description = "Espaço alocado para armazenamento no RDS (em GB)"
}

variable "dbname" {
  type        = string
  description = "Nome do banco de dados que será criado no RDS"
}

variable "engine" {
  type        = string
  description = "Engine do banco de dados RDS (ex: mysql, postgres, etc.)"
}

variable "v_engine" {
  type        = string
  description = "Versão da engine do banco de dados"
}

variable "classinstance" {
  type        = string
  description = "Classe da instância RDS (ex: db.t3.micro)"
}

variable "user" {
  type        = string
  description = "Nome de usuário para acessar o banco de dados"
}

variable "password" {
  type        = string
  description = "Senha para acessar o banco de dados"
}

variable "parameter_group_name" {
  type        = string
  description = "Nome do grupo de parâmetros do RDS"
}

variable "port" {
  type        = number
  description = "Porta usada pelo banco de dados RDS"
}

// Variáveis relacionadas ao protocolo de notificação (caso seja usado SNS, por exemplo)
variable "protocolo" {
  type        = string
  description = "Protocolo usado para notificações"
}

variable "email" {
  type        = string
  description = "E-mail para receber notificações"
}

// Variáveis do EFS
variable "efs_mount_point" {
  type        = string
  description = "Ponto de montagem do EFS nas instâncias EC2"
}

// Variável de IP
variable "myIp" {
  type        = string
  description = "IP autorizado a acessar as instâncias (usado nos Security Groups)"
}
