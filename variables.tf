variable "region" {
      default = "us-east-1"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "enable_dns_support" {
    default = "true"
}

variable "enable_dns_hostnames" {
    default ="true" 
}

  variable "preferred_number_of_public_subnets" {
      default = null
}

  variable "preferred_number_of_private_subnets" {
      default = null
}