output "serverless_inference_function_name" {
  value       = module.serverless_inference.lambda_function_name
  description = "Lambda function name from serverless inference module"
}

output "serverless_inference_function_arn" {
  value       = module.serverless_inference.lambda_function_arn
  description = "Lambda function ARN from serverless inference module"
}

output "serverless_inference_function_url" {
  value       = module.serverless_inference.lambda_function_url
  description = "Lambda function URL from serverless inference module"
}
