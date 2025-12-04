import json
import os
import boto3
from botocore.exceptions import ClientError

s3 = boto3.client("s3")
BUCKET = os.environ["BUCKET_NAME"]


def lambda_handler(event, context):
    method = event.get("requestContext", {}).get("http", {}).get("method")

    if method != "GET":
        return response(400, {"error": f"Only GET method is supported, got: {method}"})

    try:
        return handle_get(event)
    except Exception as e:
        return response(500, {"error": str(e)})


def handle_get(event):
    params = event.get("queryStringParameters", {}) or {}
    prefix = params.get("prefix", "")

    try:
        objects = []
        paginator = s3.get_paginator("list_objects_v2")

        for page in paginator.paginate(Bucket=BUCKET, Prefix=prefix):
            for obj in page.get("Contents", []):
                objects.append({
                    "key": obj["Key"],
                    "size": obj["Size"],
                    "last_modified": obj["LastModified"].isoformat()
                })

        return response(200, {
            "bucket": BUCKET,
            "prefix": prefix,
            "object_count": len(objects),
            "objects": objects
        })

    except ClientError as e:
        return response(500, {"error": e.response["Error"]["Message"]})


# -------------------------------
# HTTP Response helper
# -------------------------------
def response(status, body):
    return {
        "statusCode": status,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body)
    }
