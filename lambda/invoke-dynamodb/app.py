import json
import os
import boto3
from decimal import Decimal

# DynamoDB setup
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])


# ----------------------------------------------------
# Convert all DynamoDB Decimals safely
# ----------------------------------------------------
def to_json_safe(obj):
    if isinstance(obj, Decimal):
        # Convert Decimals to int or float
        return int(obj) if obj % 1 == 0 else float(obj)
    elif isinstance(obj, list):
        return [to_json_safe(v) for v in obj]
    elif isinstance(obj, dict):
        return {k: to_json_safe(v) for k, v in obj.items()}
    else:
        return obj


# ----------------------------------------------------
# MAIN HANDLER
# ----------------------------------------------------
def lambda_handler(event, context):
    print("DEBUG EVENT:", json.dumps(event))  # <-- Helpful for CloudWatch logs

    method = event.get("requestContext", {}).get("http", {}).get("method")

    try:
        if method == "POST":
            return handle_post(event)
        elif method == "GET":
            return handle_get(event)
        else:
            return error_response(400, f"Unsupported method {method}")
    except Exception as e:
        print("ERROR:", str(e))
        return error_response(500, str(e))


# ----------------------------------------------------
# POST: Insert or Update
# ----------------------------------------------------
def handle_post(event):
    if "body" not in event or not event["body"]:
        return error_response(400, "Missing JSON body")

    body = json.loads(event["body"])

    if "id" not in body or "number" not in body:
        return error_response(400, "Fields 'id' and 'number' are required")

    item = {
        "id": str(body["id"]),
        "number": int(body["number"])
    }

    table.put_item(Item=item)

    return success_response({
        "message": "Item stored successfully",
        "item": item
    })


# ----------------------------------------------------
# GET: Retrieve item by ID
# ----------------------------------------------------
def handle_get(event):
    params = event.get("queryStringParameters", {}) or {}

    if "id" not in params:
        return error_response(400, "Query parameter 'id' is required")

    the_id = params["id"]

    result = table.get_item(Key={"id": the_id})

    if "Item" not in result:
        return error_response(404, f"Item with id={the_id} not found")

    # Convert Decimal -> int/float
    clean_item = to_json_safe(result["Item"])

    return success_response(clean_item)


# ----------------------------------------------------
# SUCCESS + ERROR RESPONSE BUILDERS
# ----------------------------------------------------
def success_response(body):
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(to_json_safe(body))
    }


def error_response(status, message):
    return {
        "statusCode": status,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"error": message})
    }
