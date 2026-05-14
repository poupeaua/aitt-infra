# Data source for the existing VPC
data "aws_vpc" "selected" {
  id = var.vpc_id
}

# Data source for a subnet within the VPC
# This will pick the first available subnet in the VPC.
# You might want to specify a particular subnet based on your architecture.
data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnet" "selected" {
  id = data.aws_subnets.subnets.ids[0]
}

data "aws_ami" "ami_ec2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"] # Use wildcards for minor versions
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}