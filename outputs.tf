output "instance_ids" {
  description = "IDs of the created EC2 instances"
  value = aws_instance.web[*].id
}

output "public_ips" {
  description = "Public IPs of the created EC2 instances"
  value = aws_instance.web[*].public_ip
}
output "private_ips" {
  description = "Private IPs of the created EC2 instances"
  value = aws_instance.web[*].private_ip
}
# output "instance_ids" {
#   value = { for name, inst in aws_instance.web : name => inst.id }
# }

# output "instance_public_ips" {
#   value = { for name, inst in aws_instance.web : name => inst.public_ip }
# }