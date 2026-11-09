variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project resource name"
  type        = string
  default     = "terraform-separate"
}

variable "container_image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "desired_count" {
  description = "Number of ECS tasks per service"
  type        = number
  default     = 1
}
