variable "prefix" {
  description = "Prefix used for naming Lambda resources"
  type        = string
}

variable "container_registry" {
  description = "ECR registry URI (e.g., 123456789012.dkr.ecr.ap-northeast-2.amazonaws.com)"
  type        = string
}

variable "container_repository" {
  description = "ECR repository name (e.g., serverless-inference)"
  type        = string
}

variable "container_image_tag" {
  description = "Tag for the image in the ECR repository (e.g., latest)"
  type        = string
}

variable "model_s3_url" {
  description = "S3 URL where the model zip is located"
  type        = string
}

variable "ram_mib" {
  description = "Lambda memory size (MiB)"
  type        = number
  default     = 2048
}

variable "timeout_s" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 120
}

variable "log_retention_days" {
  description = "Number of days to keep CloudWatch logs"
  type        = number
  default     = 30
}

variable "environment" {
  description = "Deployment environment name (dev, prod)"
  type        = string
  default     = "dev"
}
