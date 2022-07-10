# def handler(event, context):
# 	resp = {
# 		"statusCode": 200,
# 		"headers": {
# 			"Access-Control-Allow-Origin": "*",
# 		},
# 		"body": "Hortz >> Hertz"
# 	}

# 	return resp
import boto3, json

def handler(event, context):
    client = boto3.client('dynamodb')
    client.put_item(Item= {
            "userId": {
                "S": "1"
            },
            "username": {
                "S": "Gabitox3000"
            }
        },
        TableName='users')
		
    return {
        "statusCode": 200,
        "headers": { 
            "Access-Control-Allow-Origin": "*", 
        },
        "body": "Uploaded user"
    }