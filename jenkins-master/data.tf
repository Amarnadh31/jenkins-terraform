data "aws_vpc" "master" {
  default = true
}


data "aws_ami" "master_ami"{
    most_recent = true
    owners = ["973714476881"]

    filter {
        name = "name"
        values = ["RHEL-9-DevOps-Practice"]
    }
    filter {
        name = "root-device-type"
        values = ["ebs"]
    }
}


data "aws_route_table" "master" {
  vpc_id = data.aws_vpc.master.id
}

data "aws_subnet" "master" {
    filter {
    name   = "vpc-id"
    values = [data.aws_vpc.master.id]  # Replace with your VPC ID variable
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]  # Replace with the correct AZ
  }

}

# data "aws_ssm_parameter" "jenkins_master_sg_id" {
#   name  = "/${var.project}/${var.environment}/jenkins-master-sg"
# }