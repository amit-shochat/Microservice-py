variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-2"
}
variable "instance_count" {
  description = "Number of instance to launch ."
  default     = "1"
}
variable "instance_name" {
  description = "The instance name ."
  default     = "I'm A microservice"
}

variable "ssh_key_name" {
  description = "SSH key name on AWS."
  default     = ""
}