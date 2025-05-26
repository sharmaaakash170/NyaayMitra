variable "tags" {
  type = map(string)
}

variable "env" {
  type = string
}

variable "eks_cluster_role_arn" {
  type = string
}

variable "eks_node_group_role_arn" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "instance_types" {
  type = list(string)
}

