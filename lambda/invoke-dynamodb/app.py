import json
import os
import boto3
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])


def lambda_handler(event, context):
    method = event.get("requestContext", {}).get("http", {}).get("method")
    path   = event.get("requestContext", {}).get("http", {}).get("path")

    try:
        if method == "POST":
            return handle_post(event)
        elif method == "GET":
            return handle_get(event)
        else:
            return response(400, {"error": f"Unsupported method {method}"})
    except Exception as e:
        return response(500, {"error": str(e)})


# -------------------------------
# POST Handler: Insert/Update item
# -------------------------------
def handle_post(event):
    if "body" not in event or not event["body"]:
        return response(400, {"error": "Missing JSON body"})

    body = json.loads(event["body"])

    if "id" not in body or "number" not in body:
        return response(400, {"error": "Fields 'id' and 'number' are required"})

    item = {
        "id": str(body["id"]),
        "number": int(body["number"])
    }

    table.put_item(Item=item)

    return response(200, {
        "message": "Item stored successfully",
        "item": item
    })


# -------------------------------
# GET Handler: Retrieve item by ID
# -------------------------------
def handle_get(event):
    params = event.get("queryStringParameters", {}) or {}

    if "id" not in params:
        return response(400, {"error": "Query parameter 'id' is required"})

    the_id = params["id"]

    result = table.get_item(Key={"id": the_id})

    if "Item" not in result:
        return response(404, {"error": f"Item with id={the_id} not found"})

    return response(200, result["Item"])


# -------------------------------
# HTTP Response helper
# -------------------------------
def response(status, body):
    return {
        "statusCode": status,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body)
    }
