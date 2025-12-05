# aws-project-serverless-app-deployment
## Test Scripts
http_api_endpoint = "https://ynturx4et2.execute-api.ca-central-1.amazonaws.com/"

#Invoke_DynamoDB

#Add Record

curl -X POST "https://ynturx4et2.execute-api.ca-central-1.amazonaws.com/invoke/dynamodb" \
  -H "Content-Type: application/json" \
  -d '{"id": "123", "number": 42}'

curl -X POST "https://ynturx4et2.execute-api.ca-central-1.amazonaws.com/invoke/dynamodb" \
  -H "Content-Type: application/json" \
  -d '{"id": "124", "number": 44}'

curl -X POST "https://ynturx4et2.execute-api.ca-central-1.amazonaws.com/invoke/dynamodb" \
  -H "Content-Type: application/json" \
  -d '{"id": "125", "number": 45}'

curl -X POST "https://ynturx4et2.execute-api.ca-central-1.amazonaws.com/invoke/dynamodb" \
  -H "Content-Type: application/json" \
  -d '{"id": "126", "number": 46}'

#Get Record
curl -X GET "https://ynturx4et2.execute-api.ca-central-1.amazonaws.com/invoke/dynamodb?id=123"


#Invoke_S3
# To get Files at the root level
curl -X GET "https://ynturx4et2.execute-api.ca-central-1.amazonaws.com/invoke/s3"

# To get list of files at a S3 prefix - data

curl -X GET "https://ynturx4et2.execute-api.ca-central-1.amazonaws.com/invoke/s3?prefix=data/"


# Invoke_Glue
# Invoke Glue to run
curl -X POST "https://ynturx4et2.execute-api.ca-central-1.amazonaws.com/invoke/glue"


# Invoke Glue with arguments
curl -X POST "https://ynturx4et2.execute-api.ca-central-1.amazonaws.com/invoke/glue" \
  -H "Content-Type: application/json" \
  -d '{
        "arguments": {
            "--s3_input_path": "s3://metroc-ccp-aws-project2-app3-glue-harun/jobs/",
            "--s3_output_path": "s3://metroc-ccp-aws-project2-app3-glue-harun/output/"
        }
      }'
