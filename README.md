# aws-project-serverless-app-deployment
## Test Scripts
http_api_endpoint = "https://ynturx4et2.execute-api.ca-central-1.amazonaws.com/"

#Invoke_DynamoDB

curl -X POST "https://ynturx4et2.execute-api.ca-central-1.amazonaws.com/invoke/dynamodb" \
  -H "Content-Type: application/json" \
  -d '{"id": "123", "number": 42}'

curl -X POST "https://ynturx4et2.execute-api.ca-central-1.amazonaws.com/invoke/dynamodb" \
  -H "Content-Type: application/json" \
  -d '{"id": "124", "number": 44}'

curl -X POST "https://ynturx4et2.execute-api.ca-central-1.amazonaws.com/invoke/dynamodb" \
  -H "Content-Type: application/json" \
  -d '{"id": "125", "number": 45}'
