terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# Create a VPC
resource "aws_vpc" "mn3m-vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  tags = {
     Name = "mn3m-vpc"
   }
}

# fetch data from aws to get the list of availability zones related to region configured in provider
data "aws_availability_zones" "available"{
  state = "available"
}

# # Create a subnet public 1
# resource "aws_subnet" "public-1" {
#   vpc_id     = aws_vpc.mn3m-vpc.id
#   cidr_block = "10.0.1.0/24"
#   map_public_ip_on_launch    = true
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = "public-1"
#   }
# }

# # Create a subnet public 2
# resource "aws_subnet" "public-2" {
#   vpc_id     = aws_vpc.mn3m-vpc.id
#   cidr_block = "10.0.2.0/24"
#   map_public_ip_on_launch    = true
#   availability_zone = "us-east-1b"

#   tags = {
#     Name = "public-2"
#   }
# }

# create public subnets
resource "aws_subnet" "public" {
  # to prevent hard coded of count we will use length fucntion
  #count = 2
  # length func doc https://developer.hashicorp.com/terraform/language/functions/length
  # if first part true use the second part if not use the third part
  count = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets 
  vpc_id = aws_vpc.mn3m-vpc.id
  # the link to cidrsubnet https://developer.hashicorp.com/terraform/language/functions/cidrsubnet
  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index + 1 )
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
     Name = format("PublicSubnet-%s",  count.index)
   }
}


# creates privte subnets
resource "aws_subnet" "private" {
  count = var.preferred_number_of_private_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_private_subnets
  vpc_id = aws_vpc.mn3m-vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8 , count.index + 2)
  map_public_ip_on_launch = true 
  availability_zone = data.aws_availability_zones.available.names[count.index]
  
 tags = {
     Name = format("PrivateSubnet-%s", count.index)
   }

}





