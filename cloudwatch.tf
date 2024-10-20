# ----------------------------Métrica de CPU para EC2 Privada----------------------------

# Cria um tópico SNS para alertas de utilização de CPU
resource "aws_sns_topic" "ec2_cpu_sns" {
  name = "ec2-cpu-utilization-alerts"
}

# Assina o tópico SNS com o e-mail fornecido
resource "aws_sns_topic_subscription" "email_subscription_CPU" {
  topic_arn = aws_sns_topic.ec2_cpu_sns.arn
  protocol  = var.protocolo # Define o protocolo de comunicação (ex: "email")
  endpoint  = var.email     # Define o e-mail que vai receber os alertas
}

# Alarme para monitorar a utilização da CPU de uma instância EC2 privada
resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
  alarm_name          = "CPU EC2 Privada"
  comparison_operator = "GreaterThanThreshold" # Aciona quando o valor excede o limite
  evaluation_periods  = 2                      # Avalia 2 períodos de 120 segundos
  metric_name         = "CPUUtilization"       # Métrica de utilização da CPU
  namespace           = "AWS/EC2"
  period              = 120       # Período de 2 minutos
  statistic           = "Average" # Estatística média da métrica
  threshold           = 80        # Limite de 80% de uso de CPU
  alarm_description   = "Alarme para monitorar a utilização da CPU da instância EC2"

  dimensions = {
    InstanceId = aws_instance.servidor_dockerl.id # Instância EC2 privada monitorada
  }

  alarm_actions = [aws_sns_topic.ec2_cpu_sns.arn] # Ação de alarme para quando a CPU passar de 80%
  ok_actions    = [aws_sns_topic.ec2_cpu_sns.arn] # Ação quando a situação voltar ao normal
}

# ----------------------------Métrica de Disponibilidade para EC2 Privada----------------------------

# Cria um tópico SNS para alertas de disponibilidade de EC2 privada
resource "aws_sns_topic" "ec2_availability_sns_pvt" {
  name = "ec2-availability-alerts"
}

# Assina o tópico SNS para receber alertas sobre disponibilidade
resource "aws_sns_topic_subscription" "email_subscription_pvt" {
  topic_arn = aws_sns_topic.ec2_availability_sns_pvt.arn
  protocol  = var.protocolo
  endpoint  = var.email
}

# Alarme para monitorar a disponibilidade de uma EC2 privada
resource "aws_cloudwatch_metric_alarm" "ec2_availability_pvt" {
  alarm_name          = "Disponibilidade EC2 Privada"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1                   # Um período de 5 minutos
  metric_name         = "StatusCheckFailed" # Métrica de verificação de status
  namespace           = "AWS/EC2"
  period              = 300       # Período de 5 minutos
  statistic           = "Minimum" # Verifica o valor mínimo da métrica
  threshold           = 0         # Se a verificação falhar, aciona o alarme
  alarm_description   = "Alarme para monitorar a disponibilidade da instância EC2"

  dimensions = {
    InstanceId = aws_instance.servidor_dockerl.id # EC2 privada sendo monitorada
  }

  alarm_actions = [aws_sns_topic.ec2_availability_sns_pvt.arn] # Ação ao disparar o alarme
  ok_actions    = [aws_sns_topic.ec2_availability_sns_pvt.arn] # Ação quando a instância estiver disponível
}

# ----------------------------Métrica de Disponibilidade para EC2 VPN----------------------------

# Cria um tópico SNS para alertas de disponibilidade de EC2 VPN
resource "aws_sns_topic" "ec2_availability_sns" {
  name = "ec2-availability-alerts"
}

# Assina o tópico SNS para receber alertas sobre a disponibilidade
resource "aws_sns_topic_subscription" "email_subscription_d" {
  topic_arn = aws_sns_topic.ec2_availability_sns.arn
  protocol  = var.protocolo
  endpoint  = var.email
}

# Alarme para monitorar a disponibilidade de uma EC2 VPN
resource "aws_cloudwatch_metric_alarm" "ec2_availability" {
  alarm_name          = "Disponibilidade EC2 VPN"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Minimum"
  threshold           = 0
  alarm_description   = "Alarme para monitorar a disponibilidade da instância EC2 VPN"

  dimensions = {
    InstanceId = aws_instance.servidor_pritunl.id # Instância VPN sendo monitorada
  }

  alarm_actions = [aws_sns_topic.ec2_availability_sns.arn]
  ok_actions    = [aws_sns_topic.ec2_availability_sns.arn]
}

# ----------------------------Métrica de NetworkIn para EC2 Wordpress----------------------------

# Cria um tópico SNS para alertas sobre o tráfego de entrada (NetworkIn)
resource "aws_sns_topic" "ec2_networkin_sns" {
  name = "ec2-networkin-alerts"
}

# Assina o tópico SNS para alertas de NetworkIn
resource "aws_sns_topic_subscription" "email_subscription_ntw" {
  topic_arn = aws_sns_topic.ec2_networkin_sns.arn
  protocol  = var.protocolo
  endpoint  = var.email
}

# Alarme para monitorar o tráfego de entrada na instância EC2 WordPress
resource "aws_cloudwatch_metric_alarm" "ec2_networkin" {
  alarm_name          = "Tráfego de entrada wordpress"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 524288000 # Limite de 500 MB
  alarm_description   = "Alarme para monitorar o tráfego de entrada da instância EC2 WordPress"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name # Referência ao grupo de Auto Scaling
  }

  alarm_actions = [aws_sns_topic.ec2_networkin_sns.arn]
  ok_actions    = [aws_sns_topic.ec2_networkin_sns.arn]
}

# ----------------------------Métrica de Burst Balance para RDS----------------------------

# Cria um tópico SNS para alertas de Burst Balance (RDS)
resource "aws_sns_topic" "rds_bb_sns" {
  name = "rds-burst-balance-alerts"
}

# Assina o tópico SNS para alertas de Burst Balance
resource "aws_sns_topic_subscription" "email_subscription_bb" {
  topic_arn = aws_sns_topic.rds_bb_sns.arn
  protocol  = var.protocolo
  endpoint  = var.email
}

# Alarme para monitorar o Burst Balance do RDS
resource "aws_cloudwatch_metric_alarm" "rds_bb" {
  alarm_name          = "Burst Balance RDS"
  comparison_operator = "LessThanThreshold" # Aciona quando o balance é inferior a 20%
  evaluation_periods  = 1
  metric_name         = "BurstBalance"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 20 # Limite de 20% de Burst Balance
  alarm_description   = "Alarme para monitorar o Burst Balance do RDS"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.bdword.id # Banco de dados monitorado
  }

  alarm_actions = [aws_sns_topic.rds_bb_sns.arn]
  ok_actions    = [aws_sns_topic.rds_bb_sns.arn]
}

# ----------------------------Métrica de CPU para RDS----------------------------

# Cria um tópico SNS para alertas de utilização de CPU no RDS
resource "aws_sns_topic" "rds_cpu_sns" {
  name = "rds-cpu-utilization-alerts"
}

# Assina o tópico SNS para alertas de CPU no RDS
resource "aws_sns_topic_subscription" "email_subscription_cpu" {
  topic_arn = aws_sns_topic.rds_cpu_sns.arn
  protocol  = var.protocolo
  endpoint  = var.email
}

# Alarme para monitorar a utilização da CPU no RDS
resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "Utilização CPU RDS"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarme para monitorar a utilização da CPU do RDS"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.bdword.id # Referência à instância do RDS
  }

  alarm_actions = [aws_sns_topic.rds_cpu_sns.arn]
  ok_actions    = [aws_sns_topic.rds_cpu_sns.arn]
}

# ----------------------------Métrica de Uso de Memória para Memcached----------------------------

# Define o nome do SNS
resource "aws_sns_topic" "memcached_memory_usage_sns" {
  name = "memcached-memory-usage-alerts"
}

# Assinatura SNS
resource "aws_sns_topic_subscription" "email_subscription_m" {
  topic_arn = aws_sns_topic.memcached_memory_usage_sns.arn
  protocol  = var.protocolo
  endpoint  = var.email
}

# Métrica de Uso de Memória, aciona mais que 80%
resource "aws_cloudwatch_metric_alarm" "memcached_memory_usage" {
  alarm_name          = "Uso Memória do Memcached"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "BytesUsedForCache"
  namespace           = "AWS/ElastiCache"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarme para monitorar o uso de memória do Memcached"

  dimensions = {
    CacheClusterId = aws_elasticache_cluster.cache_cluster.id # Referência ao cluster do Memcached
  }

  alarm_actions = [aws_sns_topic.memcached_memory_usage_sns.arn]
  ok_actions    = [aws_sns_topic.memcached_memory_usage_sns.arn]
}
