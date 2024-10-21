################## Create EFS File system ################ 
resource "aws_efs_file_system" "file_system_1" {
  creation_token   = "efs-test"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "efs-wordpress"
  }
}

################## Create EFS mount targets ################ 
resource "aws_efs_mount_target" "mount_targets" {
  count           = 2
  file_system_id  = aws_efs_file_system.file_system_1.id
  subnet_id       = local.public_subnets[count.index]
  security_groups = [aws_security_group.efs_sg.id]
}


/* resource "aws_efs_mount_target" "mount_targets":

Define um recurso do tipo aws_efs_mount_target, que é responsável por criar um ponto de montagem para um sistema de arquivos EFS. O nome interno desse recurso é mount_targets.
count = 2:

Este parâmetro usa a funcionalidade count do Terraform, permitindo criar múltiplos recursos com base no número especificado. Nesse caso, serão criados 2 mount targets.
file_system_id = aws_efs_file_system.file_system_1.id:

Este parâmetro referencia o ID do sistema de arquivos EFS que foi previamente criado. O aws_efs_file_system.file_system_1.id assume que você tem um recurso aws_efs_file_system chamado file_system_1 definido em seu código Terraform.
subnet_id = local.public_subnets[count.index]:

Este parâmetro especifica em qual sub-rede o mount target será criado. O local.public_subnets[count.index] indica que ele vai pegar uma sub-rede da lista local.public_subnets, usando o índice do contador (count.index) para acessar a sub-rede correspondente. Assim, o primeiro mount target será criado na primeira sub-rede e o segundo mount target na segunda sub-rede.
security_groups = [aws_security_group.efs_sg.id]:

Este parâmetro associa um grupo de segurança ao mount target. O grupo de segurança é especificado pelo ID do recurso aws_security_group.efs_sg, que deve ser definido em outro lugar no código. Isso permite controlar o tráfego de rede para o mount target.
Resumo
Em resumo, este código configura dois pontos de montagem (mount targets) para um sistema de arquivos EFS na AWS, cada um em sub-redes diferentes e associados a um grupo de segurança específico. Isso é útil para garantir que instâncias em diferentes sub-redes possam acessar o mesmo sistema de arquivos EFS, proporcionando alta disponibilidade e redundância.



*/