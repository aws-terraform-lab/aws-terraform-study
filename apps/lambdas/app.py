import sys
import json

def handler(event, context):
    msg = { 
        'message': 'Hello from AWS Lambda using Python' + sys.version + '!'
    }
    print(msg)
    return json.dumps(msg)