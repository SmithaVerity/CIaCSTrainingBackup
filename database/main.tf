# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY MYSQL ON RDS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


terraform {
  # This module is now only being tested with Terraform 1.1.x. However, to make upgrading easier, we are setting 1.0.0 as the minimum version.
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "< 4.0"
    }
  }
}

# ------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ------------------------------------------------------------------------------

provider "aws" {
  region     = "ap-south-1"
  access_key = "your-access-key"
  secret_key = "your-secret-key"
}


# ------------------------------------------------------------------------------
# DEPLOY SECURITY GROUP
# ------------------------------------------------------------------------------

resource "aws_security_group" "iac-db-sg" {
  name = "IaCDBSecGrp"
  description = "IaC DB Security Group 3306"

  // To Allow MySQL access
  ingress {
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    cidr_blocks = ["0.0.0.0/0"]
  } 
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------------------------
# DEPLOY MYSQL ON RDS
# ------------------------------------------------------------------------------

resource "aws_db_instance" "rds_instance" {
  allocated_storage = 20
  identifier = "iacrds"
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7.41"
  instance_class = "db.t2.micro"
  name = "shop_inventory"
  username = "admin"
  password = "admin123"
  publicly_accessible    = true
  skip_final_snapshot    = true
  
  vpc_security_group_ids = ["${aws_security_group.iac-db-sg.id}"] 
  
  tags = {
    Name = var.name_tag
  }
}