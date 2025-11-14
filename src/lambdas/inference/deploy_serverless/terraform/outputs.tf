# Serverless 추론 배포용 Terraform 출력

output "lambda_function_name" {
  value       = aws_lambda_function.lambda.function_name
  description = "Deployed Lambda function name"
}

output "lambda_function_arn" {
  value       = aws_lambda_function.lambda.arn
  description = "Lambda ARN"
}

output "lambda_function_url" {
  value       = aws_lambda_function_url.lambda_url.function_url
  description = "Public URL endpoint of the Lambda function"
}

output "lambda_role_arn" {
  value       = aws_iam_role.lambda_role.arn
  description = "IAM Role ARN for Lambda function"
}

