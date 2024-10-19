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
