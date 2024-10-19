# Criação de um grupo de Auto Scaling para as instâncias WordPress
locals {
  instance_name = "wordpress-instance"
}

# Criação de um grupo de Auto Scaling para as instâncias WordPress
resource "aws_autoscaling_group" "wordpress_asg" {
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  vpc_zone_identifier = [aws_subnet.subnet-public-1a.id, aws_subnet.subnet-public-1b.id]
  launch_template {
    id      = aws_launch_template.wordpress_lt.id
    version = "$Latest"
  }

  # Definir as tags para as instâncias geradas
  tag {
    key                 = "Name"
    value               = local.instance_name # Usando a variável local
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "Production"
    propagate_at_launch = true
  }

  tag {
    key                 = "Application"
    value               = "WordPress"
    propagate_at_launch = true
  }
}
# Criação de um template de lançamento para instâncias EC2 WordPress
resource "aws_launch_template" "wordpress_lt" {
  name_prefix   = "wordpress-lt"
  image_id      = var.ami_image
  instance_type = var.type_instance

  key_name = aws_key_pair.keypair.key_name

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.sc-ec2-wordpress.id]
  }

  user_data = base64encode(
    templatefile("ec2Wordpress.sh", {
      wp_db_name       = aws_db_instance.bdword.db_name
      wp_username      = aws_db_instance.bdword.username
      wp_user_password = aws_db_instance.bdword.password
      wp_db_host       = aws_db_instance.bdword.address
      aws_elasticache  = "${aws_elasticache_cluster.cache_cluster.cache_nodes[0].address}"
      efs_dns_name     = "${aws_efs_file_system.file_system_1.dns_name}"
    })
  )
}
