locals {
  common_tags = {
    Project   = "Projeto Final Bootcamp Elven Works"
    CreatedAt = "09/05/2024"
    ManagedBy = "Terraform"
    Owner     = "João Paulo"
    Service   = "Wordpress Turbinado"
  }
}

################## Local Variables  ################## 


locals {
  public_subnets = [
    aws_subnet.subnet-public-1a.id,
    aws_subnet.subnet-public-1b.id
  ]
}