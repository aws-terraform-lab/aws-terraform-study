import json
import boto3
client = boto3.client('dynamodb')

def handler(event, context):
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
            'body': f'successfully created item! {json.dumps(data)}',
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
        }
    else:
        return {
            'statusCode': 400,
            'body': f'cant create a lock',
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
        }