locals {
  region = "us-east-1" # don't change it :P

  vpc_a = {
    vpc_id = aws_vpc.vpc_a.id
    eni_id = aws_network_interface.eni_a.id
  }

  vpc_b = {
    vpc_id = aws_vpc.vpc_b.id
    eni_id = aws_network_interface.eni_b.id
  }
}
