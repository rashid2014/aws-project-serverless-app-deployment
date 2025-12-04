variable "aws_region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "ca-central-1"
}

variable "bucket_name" {
  type        = string
  description = "Enter Your Project Bucket Name"
  default     = "metroc-ccp-aws-project2-app2-harun"
}

variable "glue_bucket_name" {
  type        = string
  description = "Enter Your Glue Bucket Name"
  default     = "metroc-ccp-aws-project2-app3-glue-harun"
}

variable "lambda_iam_role_prefix" {
  type        = string
  description = "Enter Your IAM Role Prefix"
  default     = "Lambda_Execution_Role_with_Invoke"
}

variable "glue_iam_role_prefix" {
  type        = string
  description = "Enter Your IAM Role Prefix"
  default     = "Glue_Execution_Role_with_Invoke"
}

variable "lambda_funnction_name_prefix" {
  type        = string
  description = "Enter Your IAM Role Prefix"
  default     = "lambda_function_invoke"
}

variable "api_name" {
  type        = string
  description = "Enter Your API Name"
  default     = "AWS_Serverless_Multi_Channel_API"
}

variable "table_name" {
  type        = string
  description = "Enter Your DynamoDB table name"
  default     = "lambda-apigateway"
}

variable "job_name" {
  type        = string
  description = "Enter Your Glue Job name"
  default     = "app3-etl-job"
}

