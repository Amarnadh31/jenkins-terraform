resource "aws_ssm_parameter" "jenkins_master_sg_id" {
  name  = "/${var.project}/${var.environment}/jenkins-master-sg"
  type  = "String"
  value = module.docker_sg.sg_id
}