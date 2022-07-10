def handler(event, context):
	resp = {
		"statusCode": 200,
		"headers": {
			"Access-Control-Allow-Origin": "*",
		},
		"body": "No users yet!"
	}

	return resp