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