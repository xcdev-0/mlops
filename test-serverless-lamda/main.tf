############################################
# Serverless Inference Lambda Module
############################################
module "serverless_inference" {
  source = "../infra/services/inference/serverless_inference"

  prefix                 = "gennie-serverless"        # Lambda 이름 prefix
  container_registry     = var.container_registry     # 예: <ACCOUNT_ID>.dkr.ecr.ap-northeast-2.amazonaws.com
  container_repository   = var.container_repository   # 예: serverless-inference
  container_image_tag    = var.container_image_tag    # 예: latest

  model_s3_url           = var.model_s3_url           # 예: https://bucket.s3.ap-northeast-2.amazonaws.com/model.zip
  ram_mib                = var.ram_mib                # 예: 2048
  timeout_s              = var.timeout_s              # 예: 120

  log_retention_days     = var.log_retention_days     # 예: 30
  environment            = var.environment            # 예: dev or prod
}

provider "aws" {
  region  = var.region
  profile = var.awscli_profile
}
