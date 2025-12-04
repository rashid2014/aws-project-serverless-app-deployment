import json
import os
import boto3
from botocore.exceptions import ClientError

glue = boto3.client("glue")
GLUE_JOB_NAME = os.environ["GLUE_JOB_NAME"]


def lambda_handler(event, context):
    method = event.get("requestContext", {}).get("http", {}).get("method")

    if method != "POST":
        return response(400, {"error": f"Only POST supported, got: {method}"})

    try:
        return start_glue_job(event)
    except Exception as e:
        return response(500, {"error": str(e)})


def start_glue_job(event):
    # Parse body
    body = {}
    if event.get("body"):
        body = json.loads(event["body"])

    # Optional job arguments
    job_args = body.get("arguments", {})  # e.g. {"--input": "s3://bucket/data/"}

    try:
        result = glue.start_job_run(
            JobName=GLUE_JOB_NAME,
            Arguments=job_args
        )

        return response(200, {
            "message": "Glue job started successfully",
            "job_name": GLUE_JOB_NAME,
            "job_run_id": result["JobRunId"]
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
