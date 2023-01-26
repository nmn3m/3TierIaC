// create elastic ip 
resource "aws_eip" "mn3m-eip" {
    vpc = true
    depends_on = [
      aws_internet_gateway.mn3m-ig
    ]

    tags = {
      "Name" = "mn3mNatEIP"
    }
}

// create natgatway 
resource "aws_nat_gateway" "mn3m-nat" {
  allocation_id = aws_eip.mn3m-eip.id
  subnet_id = element(aws_subnet.public.*.id, 0)
  depends_on = [
    aws_internet_gateway.mn3m-ig
  ]

  tags = {
    "Name" = "mn3mNatGateway"
  }
}