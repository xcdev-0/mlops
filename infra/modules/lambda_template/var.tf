variable "prefix" {
  description = "Prefix for resource names (e.g., project name)"
  type        = string
  default     = "lambda-template"
}

variable "container_registry" {
  description = "ECR registry URI"
  type        = string
  default     = ""
}

variable "container_repository" {
  description = "ECR repository name"
  type        = string
  default     = ""
}

variable "container_image_tag" {
  description = "Container image tag for Lambda deployment"
  type        = string
  default     = "latest"
}

variable "ram_mib" {
  description = "Memory size (MB) allocated to the Lambda function"
  type        = number
  default     = 2048
}

variable "timeout_s" {
  description = "Timeout (seconds) for the Lambda function"
  type        = number
  default     = 120
}

variable "region_name" {
  description = "AWS region where Lambda will be deployed"
  type        = string
  default     = "ap-northeast-2"
}

variable "eks_cluster_name" {
  description = "EKS cluster name (used if Lambda interacts with EKS)"
  type        = string
  default     = ""
}

variable "state_bucket_name" {
  description = "S3 bucket name for state or shared storage"
  type        = string
  default     = ""
}

variable "db_api_url" {
  description = "Backend API endpoint for updating inference metadata"
  type        = string
  default     = ""
}

variable "karpenter_node_role_parameter_name" {
  description = "SSM parameter name storing Karpenter node IAM role ARN"
  type        = string
  default     = ""
}

variable "model_s3_url" {
  description = "S3 URL for model weights (used during inference)"
  type        = string
  default     = ""
}

variable "upload_s3_url" {
  description = "S3 upload endpoint for training or dataset uploads"
  type        = string
  default     = ""
}

# ----------------------------
# IAM Policy Attachments
# ----------------------------

variable "attach_ssm_readonly_policy" {
  description = "Attach AmazonSSMReadOnlyAccess to Lambda IAM Role"
  type        = bool
  default     = false
}

variable "attach_ec2_policy" {
  description = "Attach AmazonEC2FullAccess policy to Lambda IAM Role"
  type        = bool
  default     = false
}

variable "attach_s3_policy" {
  description = "Attach AmazonS3FullAccess policy to Lambda IAM Role"
  type        = bool
  default     = false
}

variable "attach_vpc_policy" {
  description = "Attach AmazonVPCFullAccess policy to Lambda IAM Role"
  type        = bool
  default     = false
}

variable "attach_lambda_policy" {
  description = "Attach AWSLambda_FullAccess policy to Lambda IAM Role"
  type        = bool
  default     = false
}

variable "attach_cloudwatch_policy" {
  description = "Attach CloudWatchFullAccess and CloudWatchLogsFullAccess policies"
  type        = bool
  default     = true
}

variable "attach_eks_policy" {
  description = "Attach EKS-related access policies (for kubectl control)"
  type        = bool
  default     = false
}

variable "attach_iam_policy" {
  description = "Attach IAMFullAccess policy to Lambda IAM Role"
  type        = bool
  default     = false
}

variable "attach_pricing_policy" {
  description = "Attach AWSPriceListServiceFullAccess policy"
  type        = bool
  default     = false
}

variable "attach_admin_policy" {
  description = "Attach AdministratorAccess policy to Lambda IAM Role"
  type        = bool
  default     = false
}
