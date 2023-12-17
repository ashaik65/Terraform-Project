variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1" # Change this to your preferred region
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-06aa3f7caf3a30282" # Change this to a suitable AMI for your region
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.medium"
}

variable "key_name" {
  description = "EC2 instance key"
  default     = "terraform"

}