
output "instance_name" {
  value = var.instance_name
}
output "address" {
  value = aws_elb.elb_microservice_get.dns_name
}