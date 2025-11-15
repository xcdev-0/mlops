############################################
# Provider
############################################
provider "aws" {
  region  = var.region
  profile = var.awscli_profile
}

provider "random" {}

############################################
# Random suffix
############################################
resource "random_id" "random_string" {
  byte_length = 4
}

############################################
# S3 Bucket - 모델 ZIP 저장소
############################################
module "model_storage" {
  source = "./s3_web/model_storage"
  prefix = var.prefix
}


############################################
# ECR Repository - 서버리스 추론 컨테이너 저장소
############################################
resource "aws_ecr_repository" "serverless_inference" {
  name = "${var.prefix}-serverless-inference"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.prefix}-serverless-inference"
  }
}




############################################
# Outputs
############################################
output "model_bucket_name" {
  value = module.model_storage.bucket_name
}


output "serverless_inference_ecr_repo" {
  value = aws_ecr_repository.serverless_inference.repository_url
}

