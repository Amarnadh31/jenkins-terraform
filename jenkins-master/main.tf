module "jenkins_master_sg" {
    source = "git::https://github.com/Amarnadh31/terraform-security-group-module.git"
    project_name = var.project
    sg_name = "jenkins-master-sg"
    environment_name = var.environment
    vpc_id = data.aws_vpc.master.id
    common_tags = var.common_tags
    sg_tags = var.master_tags

}

resource "aws_security_group_rule" "jenkins_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.jenkins_master_sg.sg_id

}

resource "aws_security_group_rule" "jenkins_port80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.jenkins_master_sg.sg_id

}

resource "aws_security_group_rule" "jenkins_port3306" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.jenkins_master_sg.sg_id

}

resource "aws_security_group_rule" "jenkins_port8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.jenkins_master_sg.sg_id

}



resource "aws_instance" "master" {

  instance_type          = "t2.micro"
  ami = data.aws_ami.master_ami.id
  vpc_security_group_ids = [data.aws_ssm_parameter.jenkins_master_sg_id.value]
  subnet_id              = data.aws_subnet.master.id
  associate_public_ip_address = true

  tags = merge(
    var.common_tags,
    var.master_tags,
    {
      Name= local.resource_name
    }
  )
}


resource "null_resource" "docker_scripts" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = aws_instance.master.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = aws_instance.master.public_ip
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
  }

  provisioner "file" {
    source = "master-script.sh"
    destination = "/tmp/master-script.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "sudo chmod +x /tmp/master-script.sh",
      "sudo sh /tmp/master-script.sh"
    ]
  }
}

resource "aws_route_table_association" "jenkins_master" {
  subnet_id      = data.aws_subnet.master.id
  route_table_id = data.aws_route_table.master.id
}


resource "aws_ebs_volume" "master_volume" {
  availability_zone = "us-east-1a"
  size              = 50
  type = "gp3"
  throughput = 125
  iops = 3000

  tags = {
    Name = "master_vol"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.master_volume.id
  instance_id = aws_instance.master.id
}