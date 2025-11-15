############################################
# Variables for Serverless Inference Module
############################################
variable "region" {
  default = "ap-northeast-2"
}

variable "awscli_profile" {
    default = "default"
}

variable "prefix" {
  description = "Name prefix for Lambda and related resources"
  type        = string
  default     = "gennie-serverless"
}

variable "container_registry" {
  description = "ECR registry URI (account.dkr.ecr.region.amazonaws.com)"
  type        = string
  default     = "972775291226.dkr.ecr.ap-northeast-2.amazonaws.com"
}

variable "container_repository" {
  description = "ECR repository name"
  type        = string
  default     = "gennie-serverless-inference"
}

variable "container_image_tag" {
  description = "Tag for the ECR image"
  type        = string
  default     = "v2"
}

variable "model_s3_url" {
  description = "Full S3 URL of the model.zip"
  type        = string

  # 예시 URL (네 bucket name 넣음)
  default = "https://gennie-model-storage-dd36181f.s3.ap-northeast-2.amazonaws.com/test-zip.zip"  
}

variable "ram_mib" {
  description = "Lambda memory size (MB)"
  type        = number
  default     = 2048
}

variable "timeout_s" {
  description = "Lambda timeout (sec)"
  type        = number
  default     = 120
}

variable "log_retention_days" {
  description = "CloudWatch log retention days"
  type        = number
  default     = 30
}

variable "environment" {
  description = "Environment name (dev/stage/prod)"
  type        = string
  default     = "dev"
}
