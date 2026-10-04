variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "Availability zone for the EC2 instance"
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "trial-instance"
}

variable "key_name" {
  description = "Name of the AWS key pair"
  type        = string
  default     = "trialKey"
}

variable "public_key_path" {
  description = "Path to the SSH public key file (.pub)"
  type        = string
  default     = "trialKey.pub"
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
  default     = "trial-sg"
}

variable "my_ip" {
  description = "Your public IP in CIDR form (e.g. 203.0.113.10/32) allowed to SSH"
  type        = string

  validation {
    condition     = can(cidrhost(var.my_ip, 0))
    error_message = "my_ip must be a valid CIDR block, e.g. 203.0.113.10/32."
  }
}

variable "http_cidr" {
  description = "CIDR allowed to reach port 80"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ami_name_filter" {
  description = "AMI name pattern to search for"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "ami_owner" {
  description = "AMI owner account ID (099720109477 = Canonical)"
  type        = string
  default     = "099720109477"
}
