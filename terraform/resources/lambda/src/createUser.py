def handler(event, context):
	resp = {
		"statusCode": 200,
		"headers": {
			"Access-Control-Allow-Origin": "*",
		},
		"body": "User  successfully created"
	}

	return resp