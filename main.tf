terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

}

provider "aws" {
  region = var.region
}

resource "aws_key_pair" "keypair" {
  key_name   = "terraform-keypair"
  public_key = file("C:/Users/Praetorian/Desktop/ch/id_ed25519.pub")

}


