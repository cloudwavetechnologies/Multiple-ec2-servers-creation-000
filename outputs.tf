output "instance_ids" {
  value = aws_instance.web[*].id
}

output "instance_public_ips" {
  value = aws_instance.web[*].public_ip
}
output "instance_ids" {
  value = { for name, inst in aws_instance.web : name => inst.id }
}

output "instance_public_ips" {
  value = { for name, inst in aws_instance.web : name => inst.public_ip }
}