output "vpc_a" {
  value = local.vpc_a
}

output "vpc_b" {
  value = local.vpc_b
}

output "vpc_peering_id" {
  value = aws_vpc_peering_connection.main.id
}
