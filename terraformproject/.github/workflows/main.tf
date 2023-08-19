#How to create EC2 with key pair attached
resource "aws_instance" "this" {
    ami             = var.ami
    instance_type   = "t2.micro"
    key_name        = "EC2"
    security_groups = [aws_security_group.terraformEc2_security.name]
    user_data =file("${path.module}/lamp.sh")
    tags = {
      Name = "EC2"
  }
}

variable "ami" {
  type        = string
  default     = "ami-0b0dcb5067f052a63"
  description = "description"
}