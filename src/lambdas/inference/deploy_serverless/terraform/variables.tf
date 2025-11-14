# Serverless 추론 배포용 Terraform 변수

variable "prefix" {
  description = "Name prefix for resources"
  type        = string
}

variable "container_registry" {
  description = "ECR registry URI"
  type        = string
}

variable "container_repository" {
  description = "ECR repository name"
  type        = string
}

variable "container_image_tag" {
  description = "Container image tag (e.g., latest)"
  type        = string
  default     = "latest"
}

variable "ram_mib" {
  description = "Lambda memory size in MiB"
  type        = number
  default     = 2048
}

variable "timeout_s" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 120
}

variable "model_s3_url" {
  description = "S3 URL for the model file"
  type        = string
  default     = ""
}

variable "log_retention_days" {
  description = "CloudWatch log retention period"
  type        = number
  default     = 30
}

variable "environment" {
  description = "Deployment environment tag (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "region_name" {
  description = "AWS region where Lambda will be deployed"
  type        = string
  default     = "ap-northeast-2"
}

