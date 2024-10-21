locals {
  common_tags = {
    Project   = "Projeto Final Bootcamp Elven Works"
    CreatedAt = "19/05/2024"
    ManagedBy = "Terraform"
    Owner     = "João Paulo"
    Service   = "Wordpress Turbinado"
  }
}

################## Local Variables  ################## 


locals {
  public_subnets = [
    aws_subnet.subnet-public-1a.id,
    aws_subnet.subnet-public-1b.id,
    aws_subnet.subnet-private-2a.id,
    aws_subnet.subnet-private-2b.id
  ]
}


## Variavel autoscaling  que irá taguear as instancias ##

locals {
  instance_name = "wordpress-instance"
}