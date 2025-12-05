# Package the Lambda function code
data "archive_file" "lambda_invoke_dynamodb" {
  type        = "zip"
  source_file = "${path.module}/lambda/invoke-dynamodb/app.py"
  output_path = "${path.module}/lambda/invoke-dynamodb/function.zip"
}

data "archive_file" "lambda_invoke_s3" {
  type        = "zip"
  source_file = "${path.module}/lambda/invoke-s3/app.py"
  output_path = "${path.module}/lambda/invoke-s3/function.zip"
}

data "archive_file" "lambda_invoke_glue" {
  type        = "zip"
  source_file = "${path.module}/lambda/invoke-glue/app.py"
  output_path = "${path.module}/lambda/invoke-glue/function.zip"
}

# Lambda function
resource "aws_lambda_function" "invoke_dynamodb" {
  filename         = data.archive_file.lambda_invoke_dynamodb.output_path
  function_name    = "${var.lambda_funnction_name_prefix}_dynamodb"
  role             = aws_iam_role.lambda_role_dynamodb.arn
  handler          = "app.lambda_handler"
  source_code_hash = data.archive_file.lambda_invoke_dynamodb.output_base64sha256

  runtime = "python3.13"

  environment {
    variables = {
      ENVIRONMENT = "production"
      LOG_LEVEL   = "info"
      TABLE_NAME  = var.table_name
    }
  }

  tags = {
    Environment = "production"
    Application = "App1"
  }
}


resource "aws_lambda_function" "invoke_s3" {
  filename         = data.archive_file.lambda_invoke_s3.output_path
  function_name    = "${var.lambda_funnction_name_prefix}_s3"
  role             = aws_iam_role.lambda_role_s3.arn
  handler          = "app.lambda_handler"
  source_code_hash = data.archive_file.lambda_invoke_s3.output_base64sha256

  runtime = "python3.13"

  environment {
    variables = {
      ENVIRONMENT = "production"
      LOG_LEVEL   = "info"
      BUCKET_NAME = var.bucket_name
    }
  }

  tags = {
    Environment = "production"
    Application = "App2"
  }
}


resource "aws_lambda_function" "invoke_glue" {
  filename         = data.archive_file.lambda_invoke_glue.output_path
  function_name    = "${var.lambda_funnction_name_prefix}_glue"
  role             = aws_iam_role.lambda_role_glue.arn
  handler          = "app.lambda_handler"
  source_code_hash = data.archive_file.lambda_invoke_glue.output_base64sha256

  runtime = "python3.13"

  environment {
    variables = {
      ENVIRONMENT   = "production"
      LOG_LEVEL     = "info"
      GLUE_JOB_NAME = var.job_name
    }
  }

  tags = {
    Environment = "production"
    Application = "App3"
  }
}