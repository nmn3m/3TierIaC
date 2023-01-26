resource "aws_internet_gateway" "mn3m-ig" {
  vpc_id = aws_vpc.mn3m-vpc.id


// need to use merge and format func
   tags = {
     Name = "mn3m-ig"
   
}
}