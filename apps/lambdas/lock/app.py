import json
import boto3
client = boto3.client('dynamodb')

def handler(event, context):
    try:
        jobId = json.loads(event.get("body", None)).get("jobId", None)

        if jobId: 
            data = client.put_item(
                TableName='jobs-state',
                Item={
                    'JobId': {
                        'S': jobId
                    },
                    'State': {
                        'S': 'locked'
                    }
                }
            )

            return {
                'statusCode': 200,
                'body': json.dumps({ 
                    'message': f"successfully created lock of job {jobId}",
                    'status': 'locked'
                }),
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
            }
        else:
            return {
                'statusCode': 400,
                'body': json.dumps({ 
                    'message': f"can not create jock lock for jobId: {jobId}",
                }),
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
            }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({ 
                "error": str(e)
            }),
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
        }