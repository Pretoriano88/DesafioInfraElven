resource "aws_instance" "servidor_dockerl" {
  ami           = var.ami_image
  instance_type = var.type_instance

  // Amarrando a keypair acima a instancia ec2 
  key_name = aws_key_pair.keypair.key_name

  // Amarrando a instancia EC2 a subnet  
  subnet_id = aws_subnet.subnet-private-2b.id

  // Qual security group minha instancia ficará 
  vpc_security_group_ids = [aws_security_group.sg_docker.id]

  # User data - script de inicialização
  user_data = base64encode(
    templatefile("hello_world_docker.sh", {
      efs_dns_name     = "${aws_efs_file_system.file_system_1.dns_name}" 
    })
  )




  tags = merge(local.common_tags, {
    Name = "EC2 Docker"
  })

}