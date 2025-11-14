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
