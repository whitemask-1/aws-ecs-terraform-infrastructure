# variables.tf - Define customizable settings

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name for the ECS cluster"
  type        = string
  default     = "my-first-cluster"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "container_image" {
  description = "Docker image to run"
  type        = string
  default     = "nginx:latest"
}