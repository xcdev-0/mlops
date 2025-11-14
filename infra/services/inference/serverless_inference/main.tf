# Lambda 실행 IAM Role
resource "aws_iam_role" "lambda_role" {
  name = "${var.prefix}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Lambda 기본 실행 정책 (CloudWatch 로그 포함)
resource "aws_iam_role_policy_attachment" "lambda_basic_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda 함수 (컨테이너 이미지 기반)
resource "aws_lambda_function" "lambda" {
  function_name = "${var.prefix}-lambda"
  package_type  = "Image"
  architectures = ["x86_64"]
  image_uri     = "${var.container_registry}/${var.container_repository}:${var.container_image_tag}"

  memory_size = var.ram_mib
  timeout     = var.timeout_s
  role        = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      MODEL_S3_URL = var.model_s3_url
    }
  }

  tags = {
    Name        = "${var.prefix}-lambda"
    Environment = var.environment
  }
}

# CloudWatch 로그 그룹
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = var.log_retention_days
}

# Lambda Function URL
resource "aws_lambda_function_url" "lambda_url" {
  function_name      = aws_lambda_function.lambda.function_name
  authorization_type = "NONE"
}
