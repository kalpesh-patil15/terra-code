terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"


  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

#  enable_nat_gateway = true
#  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
  }
}

#ec2 public 
module "test-pub" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  
#  name = test-pub


  ami                    = "ami-01a4f99c4ac11b03c"
  instance_type          = "t2.micro"
  key_name               = "test-key1"
  monitoring             = true
#  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              =  element(module.vpc.public_subnets, 0) 

  tags = {
    Terraform   = "true"
  }
}
