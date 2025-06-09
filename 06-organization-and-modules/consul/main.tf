terraform {
  # Assumes s3 bucket and dynamo DB table already set up
  # See /code/03-basics/aws-backend
  backend "s3" {
    bucket         = "itsr-directive-tf-state"
    key            = "06-organization-and-modules/consul/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

############################################################
##
## NOTE: if you are deploying this in your production setup
## follow the instructions in the github repo on how to modify
## deploying with the defaults here as an example of the power
## of modules.
##
## REPO: https://github.com/hashicorp/terraform-aws-consul
##
############################################################
module "consul" {
  source ="hashicorp/consul/aws" #"git@github.com:hashicorp/terraform-aws-consul.git"

  version = "0.11.0"

  ami_id = "ami-0c5d02f5c0e54bbc4"

  # Hier die AMI-ID für us-east-1
  # ami_map = {
  #  "us-east-1" = "ami-0c5d02f5c0e54bbc4"
  # }
}
