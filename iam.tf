# IAM role for Glue jobs
resource "aws_iam_role" "glue_job_role" {
  name = "${var.glue_iam_role_prefix}_S3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })
}

#Lambda-1 IAM role

resource "aws_iam_role" "lambda_role_dynamodb" {
  name = "${var.lambda_iam_role_prefix}_dynamodb"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "lambda_execution_role_dynamodb_access"
  }
}


resource "aws_iam_role" "lambda_role_s3" {
  name = "${var.lambda_iam_role_prefix}_s3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "lambda_execution_role_s3_access"
  }
}

resource "aws_iam_role" "lambda_role_glue" {
  name = "${var.lambda_iam_role_prefix}_glue"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "lambda_execution_role_glue_access"
  }
}


resource "aws_iam_policy" "dynamodb_policy" {
  name        = "app1_dynamodb_fullAccess_policy"
  path        = "/"
  description = "app1_dynamodb_fullAccess_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "s3_policy" {
  name        = "app2_s3_fullAccess_policy"
  path        = "/"
  description = "app2_s3_fullAccess_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "glue_policy" {
  name        = "app3_glue_fullAccess_policy"
  path        = "/"
  description = "app3_glue_fullAccess_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "glue:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "glue-role_s3_policy_attach" {
  role       = aws_iam_role.glue_job_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda-role_dynamodb_policy_attach" {
  role       = aws_iam_role.lambda_role_dynamodb.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda-role_s3_policy_attach" {
  role       = aws_iam_role.lambda_role_s3.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda-role_glue_policy_attach" {
  role       = aws_iam_role.lambda_role_glue.name
  policy_arn = aws_iam_policy.glue_policy.arn
}