# create private route table  for private subnets
resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.mn3m-vpc.id
  
  tags = {
    "Name" = "private-Route-Table"
  }
}

# associate all private subnets to the private route table 
resource "aws_route_table_association" "private-sub-association" {
  count = length(aws_subnet.private[*].id)
  subnet_id = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private-rtb.id
}

# create public route table for public subnets
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.mn3m-vpc.id
  tags = {
    "Name" = "public-Route-Table"
  }
}

# create route for the pulic route table and attach the internet gateway
resource "aws_route" "public-rtb-route" {
  route_table_id = aws_route_table.public-rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id= aws_internet_gateway.mn3m-ig.id

}

# associate all public subnets to the public route table
resource "aws_route_table_association" "public-subnets-association" {
    count = length(aws_subnet.public[*].id)
    subnet_id = element(aws_subnet.public[*].id, count.index)
    route_table_id = aws_route_table.public-rtb.id
  
}