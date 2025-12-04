resource "aws_s3_bucket" "app2_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_acl" "app2_bucket_acl" {
  bucket = aws_s3_bucket.app2_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "app2_bucket_versioning" {
  bucket = aws_s3_bucket.app2_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Glue Bucket

resource "aws_s3_bucket" "glue_scripts" {
  bucket = var.glue_bucket_name

  tags = {
    Name        = var.glue_bucket_name
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_acl" "app3_bucket_acl" {
  bucket = aws_s3_bucket.glue_scripts.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "app3_bucket_versioning" {
  bucket = aws_s3_bucket.glue_scripts.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "glue_etl_script" {
  bucket = aws_s3_bucket.glue_scripts.id
  key    = "jobs/etl_job.py"
  source = "jobs/etl_job.py" # Make sure this file exists locally
}

resource "aws_s3_object" "glue_etl_data1" {
  bucket = aws_s3_bucket.glue_scripts.id
  key    = "jobs/data.json"
  source = "jobs/data.json" # Make sure this file exists locally
}

resource "aws_s3_object" "glue_etl_data2" {
  bucket = aws_s3_bucket.glue_scripts.id
  key    = "jobs/data.csv"
  source = "jobs/data.csv" # Make sure this file exists locally
}