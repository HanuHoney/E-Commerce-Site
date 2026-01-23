variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_tenancy" {
  description = "Instance tenancy for the VPC"
  type        = string
  default     = "default"
}

variable "availability_zone_state" {
  description = "State filter for availability zones"
  type        = string
  default     = "available"
}

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets"
  type        = number
  default     = 2
}

variable "public_subnet_cidr_offset" {
  description = "CIDR offset for public subnets (e.g., 101 for 10.0.101.0/24)"
  type        = number
  default     = 101
}

variable "private_subnet_cidr_offset" {
  description = "CIDR offset for private subnets (e.g., 1 for 10.0.1.0/24)"
  type        = number
  default     = 1
}

variable "map_public_ip_on_launch" {
  description = "Assign public IPs to instances launched in public subnets"
  type        = bool
  default     = true
}