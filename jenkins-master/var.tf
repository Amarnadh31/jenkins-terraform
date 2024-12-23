variable "project" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Terraform = true
        Environment = "dev"
    }
  
}

variable "master_tags" {
    default = {
        component = "jenkins"
    }
  
}