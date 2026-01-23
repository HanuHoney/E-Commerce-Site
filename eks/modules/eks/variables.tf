variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.29"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the cluster"
  type        = list(string)
}

variable "node_subnet_ids" {
  description = "List of subnet IDs for the node group"
  type        = list(string)
}

variable "node_group_name" {
  description = "Name of the node group"
  type        = string
  default     = "primary"
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "instance_types" {
  description = "Instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "disk_size" {
  description = "EBS volume size in GB for worker nodes"
  type        = number
  default     = 20
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
